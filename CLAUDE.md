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
- [x] Flutter project scaffolded (`flutter create`)
- [x] Folder structure created (clean architecture)
- [x] `pubspec.yaml` with all packages added
- [x] Theme system (colors, typography, spacing tokens)
- [x] GoRouter configuration
- [x] Riverpod setup (ProviderScope)

### Animation System (Priority — in progress)
- [x] `flutter_animate` integrated and configured
- [ ] `animations` package (SharedAxis, OpenContainer, FadeThrough)
- [x] `shimmer` for skeleton loaders
- [ ] `lottie` for splash + empty states
- [x] Global animation constants (durations, curves) → `app_animations.dart`
- [x] Page transition system (fade push, fade tab switch)
- [x] Place card entry animation (fade up, translateY 12→0, stagger)
- [x] Score badge entry animation (scale 0→1 + fade, elasticOut bounce)
- [x] Card press feedback (scale 0.98, 80ms)
- [ ] Bottom sheet slide-up animation
- [ ] Map pin tap scale animation (1→1.3)
- [x] Skeleton → content crossfade (shimmer → data)
- [ ] Hero image transition (card → place detail)
- [x] Category chip selection animation (AnimatedContainer color + border)
- [x] Splash screen animation (scale + fade + slideY staggered)
- [x] Nav tab icon scale bounce on selection (easeOutBack)

### Core Widgets (Shared)
- [x] `PlaceCard` — horizontal (feed) + animated
- [x] `PlaceCard` — vertical (featured) + animated
- [x] `ScoreBadge` — large + small variants + animated entry
- [x] `CategoryChip` — unselected/selected states + animated
- [x] `ReviewCard` — expandable text, photo strip, animated entry
- [x] `PrimaryButton` with loading state + press feedback
- [ ] `BottomSheetHandle`
- [x] `SkeletonLoader` (shimmer) + `PlaceCardSkeleton`
- [x] `AppTextField` — animated focus border, label color transition
- [ ] `WilayaBadge`
- [x] `MainShell` — bottom nav with animated icons

### Auth Feature
- [x] Splash screen — white bg → orange wave rises (Headspace-style CustomPainter)
- [x] Onboarding — 3-page PageView with emoji, animated dots indicator, staggered text
- [x] Sign in screen (Google + Phone outlined buttons with press feedback)
- [ ] Phone OTP verification screen
- [x] Wilaya selection screen — searchable list, animated tiles, check icon toggle
- [ ] Food preferences selection screen
- [ ] Follow suggestions screen

### Discovery Feature
- [x] Home feed screen (animated app bar, category chips, place cards)
- [x] Category filter chips (horizontal scroll, animated stagger)
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
