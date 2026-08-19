<div align="center">

<img src="assets/branding/logo.svg" alt="JO3T app icon" width="112" height="112" />

<h1 align="center">JO3T</h1>

<p align="center">
Find places worth eating at in Algeria — ranked by the people who actually ate there.<br/>
A Flutter app for discovering restaurants, cafés and street food across the 48 wilayas.
</p>

<p align="center">
<img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS-FF6B2B?style=flat-square" alt="Platform: Android and iOS" />
<img src="https://img.shields.io/badge/Flutter-3.41-E8520A?style=flat-square" alt="Built with Flutter 3.41" />
<img src="https://img.shields.io/badge/state-Riverpod-F2630F?style=flat-square" alt="State management: Riverpod" />
<img src="https://img.shields.io/badge/backend-Firebase%20(optional)-B33E06?style=flat-square" alt="Backend: Firebase, optional" />
<img src="https://img.shields.io/badge/version-1.0.0-9E3006?style=flat-square" alt="Version 1.0.0" />
<img src="https://img.shields.io/badge/license-MIT-FF6B2B?style=flat-square" alt="MIT licensed" />
</p>

</div>

---

## Download

**There is no published build yet** — no APK, no App Store or Play listing, no tagged release.
To try JO3T you build it from source, which takes two commands:

```bash
flutter pub get
flutter run
```

The app boots on in-memory sample data, so that is enough to reach every screen. No Firebase
project, no API keys, no account. See [Run locally](#run-locally) for the backed-by-Firebase
setup.

> Screenshots and a product tour live on the site in [`website/`](website/) — a static page you
> can serve locally or deploy to Vercel.

---

## What JO3T does

**Discovery** — a *For You* feed with category chips, a daily featured pick, wilaya shortcuts,
a *Following* activity tab, and pull-to-refresh. Search adds a category grid, trending
shortcuts, a people tab, and filters for price, minimum score and open-now.

**The JO3T Score** — one number, 1 to 10, per place. A weighted review average adjusted for
recency and damped by confidence, so three glowing reviews cannot outrank three hundred. It is
computed in a Firestore-triggered Cloud Function (`functions/src/index.ts`).

**Places** — hero gallery with pinch-to-zoom, the score ring, open/closed state from a 7-day
hours table, price range, attribute chips, directions, similar places, and the full review list
with sorting and a score distribution.

**Reviews** — an animated 1–10 score picker, photo attachments, expandable text and photo
strips, sorted newest / highest / lowest.

**Map** — a Google Map with custom category pins and tap-to-preview cards. With no API key
configured it falls back to a hand-drawn illustrated map carrying the same pins.

**Contributing places** — a multi-step submission form (category, wilaya, neighbourhood, photos)
that lands in a `places_pending` moderation queue.

**Social** — follow people, an activity feed, mutual recommendations on a place, a weekly wilaya
leaderboard, and user profiles.

**Venue owners** — claim a listing through a 3-step verification, then a dashboard with score
and review stats, listing management (photos, per-day hours, menu URL, contact) and inline
replies to reviews.

**Offline** — saved place IDs, the feed (2h TTL) and place details (6h TTL) are cached in Hive,
with a banner when connectivity drops.

---

## Run locally

Needs the Flutter SDK 3.41+ and Xcode or Android Studio.

```bash
git clone https://github.com/23aneessss/jo3t-app.git
cd jo3t-app
flutter pub get
flutter run
```

### Against Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<your-project>
firebase deploy --only firestore:rules,firestore:indexes

flutter run --dart-define=USE_FIREBASE=true
```

`USE_FIREBASE=true` swaps every repository from its mock implementation to the Firestore,
Firebase Auth and Storage one. Storage uploads and Cloud Functions need the Blaze plan.

### With the real map

The Maps key is read from a Gradle property on Android and an xcconfig on iOS, so it never
reaches git:

```bash
cp ios/Flutter/Secrets.xcconfig.template ios/Flutter/Secrets.xcconfig   # set MAPS_API_KEY
flutter run --dart-define=MAPS_API_KEY=<key> -PMAPS_API_KEY=<key>
```

Enable *Maps SDK for Android* and *Maps SDK for iOS* on the key. Mobile map rendering is not
billed, but the project needs a billing account attached or the map renders watermarked.

---

## Architecture

Feature-first clean architecture. Every feature splits into `domain` (entities, repository
interfaces, use cases), `data` (Firestore and mock implementations) and `presentation` (screens,
widgets, Riverpod providers). Swapping `AppEnv.useFirebase` swaps the data layer without the
presentation layer noticing.

```
lib/
├── core/          theme tokens, router, AppEnv, Firebase init,
│                  services (FCM, storage, connectivity), Hive cache, failures
├── features/      auth · discovery · place · review · add_place · map · profile
│                  saved · leaderboard · events · notifications · venue · wilaya
├── shared/        place cards, score badge, skeletons, brand logo
└── main.dart
functions/         Cloud Functions (TypeScript) — score, Algolia sync, FCM triggers
```

**Stack** — Riverpod (state), GoRouter (navigation), google_maps_flutter, flutter_animate +
animations (motion), Hive (cache), cached_network_image, image_picker, connectivity_plus, and
the `firebase_*` family (core, auth, firestore, storage, messaging, crashlytics, analytics).

The brand mark and the onboarding illustrations are drawn in code with `CustomPainter` — there
are no raster art assets. The Arabic wordmark (جعت) is set in El Messiri, bundled under
`assets/fonts/`.

---

## Known limitations

- **Sample data is the default.** Without `USE_FIREBASE=true` the app runs on in-memory
  repositories; nothing you create survives a restart.
- **Search does not use Algolia.** The Cloud Function that syncs places to an Algolia index
  exists, but the app never queries it — search pulls up to 100 places from Firestore and filters
  them client-side by substring.
- **Google Sign-In is not implemented.** The button shows a "coming soon" message and
  `signInWithGoogle` returns a failure. Phone OTP is the working path.
- **Profile screens render sample content** rather than the signed-in Firestore user.
- **Some interactions are UI-only** — collections, check-in, RSVP and the events list hold local
  widget state and are not persisted.
- **Map gaps** — no marker clustering, no "near me" GPS mode.
- **No address autocomplete** in the add-place flow.
- **Sharing produces no shareable link** — the share sheet copies a placeholder URL.
- **Photo upload, push notifications, the score recompute and the Algolia sync** all depend on
  deployed Cloud Functions and Firebase Storage, which require the Blaze plan.
- **Test coverage is thin** — unit tests cover the score-band colour mapping only. There are no
  widget or integration tests.
- **Android-first.** iOS builds and runs, but there is no App Store release, and the Android
  release build stays unsigned until you supply `android/key.properties`.

---

## Repository map

| Path | What it holds |
|---|---|
| `firestore.rules`, `storage.rules` | access control |
| `firestore.indexes.json` | composite indexes for feed and review queries |
| `functions/src/index.ts` | JO3T Score, Algolia sync, FCM triggers, pending-place expiry |
| `.github/workflows/` | analyze + test + APK build; Firebase deploy |
| `website/` | the static marketing site |

---

## License

[MIT](LICENSE) © Anes Bouziani
