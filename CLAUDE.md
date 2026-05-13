# JO3T — Development Tracker

Algeria's community-driven food & venue discovery app.
Flutter + Firebase + Google Maps. Android-first.

---

## Stack

- **UI**: Flutter (Dart)
- **State**: Riverpod (riverpod_annotation)
- **Navigation**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage, Functions)
- **Search**: Algolia
- **Maps**: google_maps_flutter
- **Animations**: flutter_animate + animations package
- **Cache**: Hive Flutter

---

## Phase 1 — Foundation & Animations (Current)

### Project Setup
- [x] Design system document
- [x] Architecture document
- [x] App plan document
- [ ] Flutter project scaffolded (`flutter create`)
- [ ] Folder structure created (clean architecture)
- [ ] `pubspec.yaml` with all packages added
- [ ] Theme system (colors, typography, spacing tokens)
- [ ] GoRouter configuration
- [ ] Riverpod setup (ProviderScope)

### Animation System (Priority — in progress)
- [ ] `flutter_animate` integrated and configured
- [ ] `animations` package (SharedAxis, OpenContainer, FadeThrough)
- [ ] `shimmer` for skeleton loaders
- [ ] `lottie` for splash + empty states
- [ ] Global animation constants (durations, curves)
- [ ] Page transition system (slide-up + fade push, fade tab switch)
- [ ] Place card entry animation (fade up, translateY 12→0, stagger)
- [ ] Score badge entry animation (scale 0→1 + fade, elasticOut bounce)
- [ ] Card press feedback (scale 0.98, 80ms)
- [ ] Bottom sheet slide-up animation
- [ ] Map pin tap scale animation (1→1.3)
- [ ] Skeleton → content crossfade
- [ ] Hero image transition (card → place detail)
- [ ] Category chip selection animation (color + scale)
- [ ] Splash screen animation (Lottie or custom)

### Core Widgets (Shared)
- [ ] `PlaceCard` — horizontal (feed)
- [ ] `PlaceCard` — vertical (featured)
- [ ] `ScoreBadge` — large + small variants
- [ ] `CategoryChip` — unselected/selected states
- [ ] `ReviewCard`
- [ ] `PrimaryButton` with loading state
- [ ] `BottomSheetHandle`
- [ ] `SkeletonLoader` (shimmer)
- [ ] `AppTextField`
- [ ] `WilayaBadge`

### Auth Feature
- [ ] Splash screen
- [ ] Onboarding (language select: AR / FR)
- [ ] Sign in screen (Google + Phone)
- [ ] Phone OTP verification screen
- [ ] Wilaya selection screen
- [ ] Food preferences selection screen
- [ ] Follow suggestions screen

### Discovery Feature
- [ ] Home feed screen
- [ ] Category filter chips (horizontal scroll)
- [ ] Wilaya filter dropdown
- [ ] Search screen with autocomplete
- [ ] Search results list

### Place Feature
- [ ] Place profile screen
- [ ] Cover image + gallery strip
- [ ] Score display + rating breakdown
- [ ] Review list (paginated)
- [ ] Address + Google Maps deep-link
- [ ] Opening hours display
- [ ] Price range indicator
- [ ] Save to list button

### Map Feature
- [ ] Map screen with Google Maps
- [ ] Custom place pins (category icon)
- [ ] Marker clustering
- [ ] Bottom sheet preview on pin tap
- [ ] "Near me" mode

### Review Feature
- [ ] Write review screen
- [ ] 1–10 score picker
- [ ] Photo upload (image_picker + compress)
- [ ] Review submission flow

### Profile Feature
- [ ] User profile screen
- [ ] Wilaya badge
- [ ] Reviewed places list
- [ ] Want-to-try list
- [ ] Followers / Following

### Add Place Feature
- [ ] Add place form
- [ ] Category selector
- [ ] Wilaya + neighborhood selector
- [ ] Address autocomplete (Places API)
- [ ] Photo upload
- [ ] Submission confirmation

---

## Phase 2 — Social Layer (Months 4–6)

- [ ] Follow / Unfollow system
- [ ] Activity feed ("Amine reviewed Chez Fatima · Blida · 8.5")
- [ ] Mutual recommendations ("3 people you follow liked this")
- [ ] Collections / curated lists
- [ ] Share list as link
- [ ] Wilaya leaderboard (top 10, weekly)
- [ ] Push notifications (Firebase Cloud Messaging)
- [ ] Weekly digest notification

---

## Phase 3 — Maturity (Months 7–12)

- [ ] Venue owner dashboard (claim listing)
- [ ] Official photos, menu PDF, hours management
- [ ] Respond to reviews
- [ ] Events (Ramadan special, live music)
- [ ] RSVP + share event
- [ ] JO3T Score algorithm (Cloud Function)
- [ ] Offline mode (Hive cache for saved places)
- [ ] iOS release (App Store)

---

## Infrastructure

- [ ] Firebase project setup (dev / staging / prod)
- [ ] `google-services.json` per environment
- [ ] `--dart-define` environment config
- [ ] Firestore security rules
- [ ] Firestore composite indexes
- [ ] Firebase Storage rules
- [ ] Algolia index + Cloud Function sync trigger
- [ ] GitHub Actions CI pipeline
- [ ] Firebase App Distribution (beta)
- [ ] Crashlytics + Analytics

---

## Animation Progress Legend

- `[A]` = Animation implemented
- `[x]` = Feature complete
- `[ ]` = Not started
- `[~]` = In progress

---

*Last updated: 2026-05-13*
