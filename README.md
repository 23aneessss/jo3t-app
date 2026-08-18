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
</p>

</div>

---

## Download

**There is no published build yet.** No APK, no App Store or Play Store listing, and no tagged
release on this repository. To try JO3T today you build it from source — see
[Run locally](#run-locally).

The app runs fully without any backend: by default it starts on in-memory sample data, so
`flutter run` is enough to explore every screen.

---

## What JO3T includes

Everything listed here exists in the code and runs today. Anything partial is called out in
[Known limitations](#known-limitations).

**Discovery feed** — a *For You* feed of places with category filter chips, a featured
"JO3T's Pick Today" card, wilaya shortcut cards, a *Following* activity tab, and
pull-to-refresh.

**The JO3T Score** — every place carries a single 1–10 score. The scoring algorithm
(weighted review average + recency weighting + a confidence dampener so a place with 3
reviews cannot outrank one with 300) lives in `functions/src/index.ts` and runs as a
Firestore-triggered Cloud Function.

**Place profiles** — hero image with a photo gallery (swipeable, pinch-to-zoom), the score
ring, open/closed status from opening hours, a 7-day hours table, price range, category
attribute chips, directions, similar places, and the full review list with sort and a score
distribution.

**Reviews** — write a review with an animated 1–10 score picker and attach photos; read
reviews with expandable text and photo strips, sorted by newest / highest / lowest.

**Search** — a search screen with a category grid, trending shortcuts, a people tab, and a
filter sheet (category, price, minimum score, open now).

**Map** — a Google Map with custom category pins and a tap-to-preview place card. Without a
Maps API key the screen falls back to a hand-drawn illustrated map with the same pins.

**Add a place** — a multi-step submission form (category, wilaya and neighbourhood, photos)
that writes to a `places_pending` moderation queue when Firebase is enabled.

**Social layer** — follow users, an activity feed, mutual recommendations on a place
("friends who know this place"), a weekly wilaya leaderboard, and user profiles.

**Venue owner flow** — claim a listing (3-step verification), a dashboard with score and
review stats, listing management (photos, per-day hours, menu URL, contact), and inline
replies to reviews.

**Offline cache** — saved place IDs, the feed (2h TTL) and place details (6h TTL) are cached
with Hive, and an offline banner appears when connectivity drops.

**Backend, when enabled** — Firebase Auth (phone OTP), Firestore repositories for places,
reviews and users, Storage uploads, Cloud Messaging with local notifications, plus
Crashlytics and Analytics. Security rules and composite indexes are committed
(`firestore.rules`, `firestore.indexes.json`, `storage.rules`).

---

## Screenshots

Captured on an iOS Simulator from a demo build with invented sample data.

<div align="center">

| Onboarding | Discovery feed | Search |
|:---:|:---:|:---:|
| <img src="Docs/screenshots/onboarding.png" width="230" alt="Onboarding screen with an animated radar illustration and the caption Discover real places" /> | <img src="Docs/screenshots/feed.png" width="230" alt="Discovery feed with For You and Following tabs, category chips and a featured place card" /> | <img src="Docs/screenshots/search.png" width="230" alt="Search screen with a category grid and trending shortcuts" /> |

| Place profile | Profile | Sign in |
|:---:|:---:|:---:|
| <img src="Docs/screenshots/place.png" width="230" alt="Place profile showing a 9.1 out of 10 JO3T Score, action buttons and a photo gallery" /> | <img src="Docs/screenshots/profile.png" width="230" alt="User profile with achievement badges, review and follower counts, and reviewed places" /> | <img src="Docs/screenshots/signin.png" width="230" alt="Sign-in screen with the Arabic wordmark and Google, phone and guest options" /> |

</div>

---

## Run locally

Requires the Flutter SDK (3.41 or newer) and Xcode or Android Studio.

```bash
git clone https://github.com/23aneessss/jo3t-app.git
cd jo3t-app
flutter pub get
flutter run
```

That runs the app on **sample data** — no Firebase project, no API keys, no network. Every
screen is reachable.

### Running against Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<your-firebase-project>
firebase deploy --only firestore:rules,firestore:indexes

flutter run --dart-define=USE_FIREBASE=true
```

`USE_FIREBASE=true` swaps every repository from its mock implementation to the Firestore /
Firebase Auth / Storage one. Storage uploads and Cloud Functions require the Firebase Blaze
plan.

### Enabling the real map

The Maps key is read from a Gradle property on Android and an xcconfig on iOS, so it never
lands in git:

```bash
cp ios/Flutter/Secrets.xcconfig.template ios/Flutter/Secrets.xcconfig
# put your key in MAPS_API_KEY, then:
flutter run --dart-define=MAPS_API_KEY=<key> -PMAPS_API_KEY=<key>
```

Enable **Maps SDK for Android** and **Maps SDK for iOS** on the key. Mobile map rendering is
not billed by Google, but a billing account must be attached or the map renders watermarked.

---

## Architecture

Feature-first clean architecture. Each feature splits into `domain` (entities, repository
interfaces, use cases), `data` (Firestore and mock implementations), and `presentation`
(screens, widgets, Riverpod providers).

```
lib/
├── core/
│   ├── theme/         colour, typography and spacing tokens
│   ├── constants/     animation curves, durations, sizes
│   ├── router/        GoRouter config and page transitions
│   ├── config/        AppEnv — reads --dart-define flags
│   ├── firebase/      init, Crashlytics, Analytics
│   ├── services/      FCM, Storage, connectivity
│   ├── cache/         Hive offline cache with TTLs
│   └── errors/        typed Failure hierarchy
├── features/
│   ├── auth/          onboarding, phone OTP, wilaya and food preferences
│   ├── discovery/     feed, search, category filters, following tab
│   ├── place/         profile, gallery, reviews, suggest edits
│   ├── review/        write review, 1–10 score picker
│   ├── add_place/     multi-step submission
│   ├── map/           Google Map and illustrated fallback
│   ├── profile/       profile, saved, settings, edit profile
│   ├── saved/         collections
│   ├── leaderboard/   weekly wilaya ranking
│   ├── events/        event detail and RSVP
│   ├── notifications/ activity list
│   ├── venue/         owner dashboard, claim, manage listing
│   └── wilaya/        Algerian wilaya data
├── shared/widgets/    place cards, score badge, skeletons, brand logo
└── main.dart
functions/             Cloud Functions (TypeScript) — score, Algolia sync, FCM triggers
```

**Key dependencies** — `flutter_riverpod` (state), `go_router` (navigation),
`google_maps_flutter` (map), `flutter_animate` + `animations` (motion), `hive_flutter`
(cache), `cached_network_image`, `image_picker`, `connectivity_plus`, `timeago`, and the
`firebase_*` family (core, auth, firestore, storage, messaging, crashlytics, analytics).

The brand mark and the onboarding illustrations are drawn in code with `CustomPainter` —
there are no raster art assets. The Arabic wordmark (جعت) is set in El Messiri, bundled in
`assets/fonts/`.

---

## Known limitations

Honest list of what is not finished:

- **Mock data is the default.** Without `USE_FIREBASE=true` the app is a working prototype
  over in-memory repositories. Nothing you create in that mode survives a restart.
- **Search does not use Algolia.** The Cloud Function that syncs places to an Algolia index
  exists, but the app never queries it — search fetches up to 100 places from Firestore and
  filters them client-side by substring.
- **Google Sign-In is not implemented.** The button shows a "coming soon" message;
  `signInWithGoogle` returns a failure. Phone OTP is the working path.
- **Profile screens still show sample data.** The profile, settings and followers screens
  render hardcoded demo content instead of the signed-in Firestore user.
- **Some interactions are UI-only.** Collections, check-in, RSVP and the events list hold
  local widget state and are not persisted to any backend.
- **Map gaps.** No marker clustering and no "near me" GPS mode.
- **No address autocomplete** in the add-place flow (Places API is not wired up).
- **Share produces no shareable link.** The share sheet copies a placeholder URL; there is no
  deep-link backend.
- **Photo upload, push notifications, the JO3T Score recompute and the Algolia sync all
  require deployed Cloud Functions and Firebase Storage**, which need the Blaze plan.
- **Test coverage is minimal** — a single widget test.
- **Android-first.** iOS builds and runs, but there is no App Store release and the release
  build is unsigned until you supply a keystore (`android/key.properties`).

---

## Project references

- `firestore.rules`, `storage.rules` — access control
- `firestore.indexes.json` — composite indexes for the feed and review queries
- `functions/src/index.ts` — JO3T Score, Algolia sync, FCM triggers, pending-place expiry
- `.github/workflows/` — analyze, test and APK build on CI; Firebase deploy workflow
- `website/` — the static marketing site for this project

---

## License

No license file has been added yet, so default copyright applies — all rights reserved.
