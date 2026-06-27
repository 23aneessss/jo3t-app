import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

// ── JO3T Score Algorithm ───────────────────────────────────────────────────
// Triggered whenever a review is written. Recalculates the jo3tScore for the
// referenced place using a weighted blend of:
//   • Average score (base)
//   • Recency bonus (reviews in the last 90 days count more)
//   • Confidence dampener (fewer reviews → score pulled toward 5.0)

export const onReviewCreated = functions.firestore
  .document("reviews/{reviewId}")
  .onCreate(async (snap) => {
    const data = snap.data();
    const placeId: string = data.placeId;
    if (!placeId) return;

    await _recalculatePlaceScore(placeId);
    await _notifyPlaceOwner(placeId, snap.id, data);
  });

export const onReviewDeleted = functions.firestore
  .document("reviews/{reviewId}")
  .onDelete(async (snap) => {
    const placeId: string = snap.data().placeId;
    if (!placeId) return;
    await _recalculatePlaceScore(placeId);
  });

async function _recalculatePlaceScore(placeId: string): Promise<void> {
  const snap = await db
    .collection("reviews")
    .where("placeId", "==", placeId)
    .get();

  if (snap.empty) {
    await db.collection("places").doc(placeId).update({
      jo3tScore: 0,
      averageScore: 0,
      reviewCount: 0,
    });
    return;
  }

  const now = Date.now();
  const ninetyDaysMs = 90 * 24 * 60 * 60 * 1000;
  let weightedSum = 0;
  let totalWeight = 0;
  let rawSum = 0;

  for (const doc of snap.docs) {
    const d = doc.data();
    const score: number = d.score ?? 0;
    const ts: admin.firestore.Timestamp | undefined = d.createdAt;
    const ageMs = ts ? now - ts.toMillis() : ninetyDaysMs;
    // Recency weight: 1.5× for reviews < 90 days, 1.0× for older
    const recency = ageMs < ninetyDaysMs ? 1.5 : 1.0;
    weightedSum += score * recency;
    totalWeight += recency;
    rawSum += score;
  }

  const reviewCount = snap.size;
  const weightedAvg = weightedSum / totalWeight;
  const rawAvg = rawSum / reviewCount;

  // Confidence dampener: blend toward 5.0 when count < 10
  const confidence = Math.min(reviewCount / 10, 1.0);
  const jo3tScore =
    Math.round((weightedAvg * confidence + 5.0 * (1 - confidence)) * 10) / 10;

  await db.collection("places").doc(placeId).update({
    jo3tScore,
    averageScore: Math.round(rawAvg * 10) / 10,
    reviewCount,
  });
}

// ── Algolia Sync ───────────────────────────────────────────────────────────
// Syncs approved places to Algolia whenever a place doc is written.

export const syncPlaceToAlgolia = functions.firestore
  .document("places/{placeId}")
  .onWrite(async (change, context) => {
    const placeId = context.params.placeId;

    // Deleted — remove from Algolia index
    if (!change.after.exists) {
      try {
        const { default: algoliasearch } = await import("algoliasearch");
        const appId = functions.config().algolia?.app_id ?? "";
        const apiKey = functions.config().algolia?.api_key ?? "";
        if (!appId || !apiKey) return;
        const client = algoliasearch(appId, apiKey);
        const index = client.initIndex("places");
        await index.deleteObject(placeId);
      } catch (e) {
        functions.logger.error("Algolia delete failed", e);
      }
      return;
    }

    const data = change.after.data()!;
    if (!data.isApproved) return; // Only index approved places

    try {
      const { default: algoliasearch } = await import("algoliasearch");
      const appId = functions.config().algolia?.app_id ?? "";
      const apiKey = functions.config().algolia?.api_key ?? "";
      if (!appId || !apiKey) return;
      const client = algoliasearch(appId, apiKey);
      const index = client.initIndex("places");
      await index.saveObject({
        objectID: placeId,
        name: data.name,
        category: data.category,
        wilayaId: data.wilayaId,
        neighborhood: data.neighborhood,
        address: data.address,
        jo3tScore: data.jo3tScore ?? 0,
        reviewCount: data.reviewCount ?? 0,
        coverPhotoUrl: data.coverPhotoUrl ?? "",
        priceRange: data.priceRange,
        isOpen: data.isOpen ?? false,
      });
    } catch (e) {
      functions.logger.error("Algolia sync failed", e);
    }
  });

// ── FCM: New Review Notification ──────────────────────────────────────────
// Notifies the place owner when a new review is submitted.

async function _notifyPlaceOwner(
  placeId: string,
  reviewId: string,
  reviewData: admin.firestore.DocumentData
): Promise<void> {
  const placeSnap = await db.collection("places").doc(placeId).get();
  if (!placeSnap.exists) return;

  const ownerId: string | undefined = placeSnap.data()?.addedBy;
  if (!ownerId) return;

  const ownerSnap = await db.collection("users").doc(ownerId).get();
  const fcmToken: string | undefined = ownerSnap.data()?.fcmToken;
  if (!fcmToken) return;

  const placeName: string = placeSnap.data()?.name ?? "your place";
  const score: number = reviewData.score ?? 0;

  await messaging.send({
    token: fcmToken,
    notification: {
      title: `New review on ${placeName}`,
      body: `Someone gave it a ${score}/10 — tap to read.`,
    },
    data: {
      type: "new_review",
      placeId,
      reviewId,
    },
    android: {
      channelId: "jo3t_notifications",
      priority: "normal",
    },
  });
}

// ── FCM: New Follower Notification ────────────────────────────────────────

export const onFollowCreated = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const userId = context.params.userId;

    const prevFollowers: string[] = before.followers ?? [];
    const newFollowers: string[] = after.followers ?? [];

    // Find newly added follower
    const added = newFollowers.filter((id) => !prevFollowers.includes(id));
    if (added.length === 0) return;

    const fcmToken: string | undefined = after.fcmToken;
    if (!fcmToken) return;

    const followerId = added[0];
    const followerSnap = await db.collection("users").doc(followerId).get();
    const followerName: string =
      followerSnap.data()?.name ?? "Someone";

    await messaging.send({
      token: fcmToken,
      notification: {
        title: "New follower",
        body: `${followerName} started following you.`,
      },
      data: {
        type: "new_follower",
        followerId,
        targetUserId: userId,
      },
      android: {
        channelId: "jo3t_notifications",
        priority: "normal",
      },
    });
  });

// ── Pending Place: Auto-reject after 7 days ───────────────────────────────

export const expirePendingPlaces = functions.pubsub
  .schedule("every 24 hours")
  .onRun(async () => {
    const cutoff = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const snap = await db
      .collection("places_pending")
      .where("status", "==", "pending")
      .where("submittedAt", "<", cutoff)
      .get();

    const batch = db.batch();
    for (const doc of snap.docs) {
      batch.update(doc.ref, { status: "expired" });
    }
    await batch.commit();
    functions.logger.info(`Expired ${snap.size} pending places`);
  });
