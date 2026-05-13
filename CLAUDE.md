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
- [x] Bottom sheet slide-up animation (`showJo3tBottomSheet` helper)
- [ ] Map pin tap scale animation (1→1.3)
- [x] Skeleton → content crossfade (shimmer → data)
- [x] Hero image transition (card → place detail SliverAppBar)
- [x] Category chip selection animation (AnimatedContainer color + border)
- [x] Splash screen animation (scale + fade + slideY staggered)
- [x] Nav tab icon scale bounce on selection (easeOutBack)

### Core Widgets (Shared)
- [x] `PlaceCard` — horizontal (feed) + animated + Hero tag
- [x] `PlaceCard` — vertical (featured) + animated + Hero tag
- [x] `ScoreBadge` — large + small variants + animated entry
- [x] `CategoryChip` — unselected/selected states + animated
- [x] `ReviewCard` — expandable text, photo strip, animated entry
- [x] `PrimaryButton` with loading state + press feedback
- [x] `BottomSheetHandle` + `showJo3tBottomSheet` helper
- [x] `SkeletonLoader` (shimmer) + `PlaceCardSkeleton`
- [x] `AppTextField` — animated focus border, label color transition
- [x] `WilayaBadge` — location pill with icon
- [x] `MainShell` — 5-tab bottom nav with animated icons

### Auth Feature
- [x] Splash screen — white bg → orange wave rises (Headspace-style CustomPainter)
- [x] Onboarding — 3-page PageView with emoji, animated dots indicator, staggered text
- [x] Sign in screen (Google + Phone outlined buttons with press feedback)
- [ ] Phone OTP verification screen
- [x] Wilaya selection screen — searchable list, animated tiles, check icon toggle
- [x] Food preferences screen — 3×4 grid, emoji cards, selection progress bar
- [ ] Follow suggestions screen

### Discovery Feature
- [x] Home feed screen (animated app bar, category chips, place cards, skeleton loading)
- [x] Category filter chips (horizontal scroll, animated stagger, filters feed)
- [ ] Wilaya filter dropdown
- [x] Search screen — trending chips, live search with debounce, animated results
- [x] Search results list (animated entry, navigates to place profile)

### Place Feature
- [x] Place profile screen — SliverAppBar hero, score badge, quick info row
- [x] Cover image + gallery strip (staggered scale animation)
- [x] Score display (large animated ScoreBadge)
- [x] Review list (3 ReviewCards with stagger)
- [x] Address + Directions action button
- [x] Opening hours / Open-Closed status
- [x] Price range indicator
- [x] Save to list button (animated toggle bookmark)

### Map Feature
- [ ] Map screen with Google Maps (pending Firebase/Maps SDK setup)
- [ ] Custom place pins (category icon)
- [ ] Marker clustering
- [ ] Bottom sheet preview on pin tap
- [ ] "Near me" mode

### Review Feature
- [x] Write review screen
- [x] 1–10 score picker (animated circle buttons, color by score)
- [ ] Photo upload (image_picker + compress — UI shell done)
- [x] Review submission flow (mock delay + SnackBar confirmation)

### Profile Feature
- [x] User profile screen (gradient header, stats row with stagger)
- [x] Wilaya badge on profile
- [ ] Reviewed places list (real data)
- [ ] Want-to-try list
- [ ] Followers / Following

### Add Place Feature
- [x] Add place form — multi-step with animated progress bar
- [x] Category selector — emoji grid with scale/color selection animation
- [x] Wilaya + neighborhood selector — quick-pick chips + AppTextField
- [ ] Address autocomplete (Places API — pending Firebase setup)
- [x] Photo upload UI (shell done, image_picker pending Firebase)
- [x] Submission confirmation — SnackBar + 24h moderation info

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

*Last updated: 2026-05-14*
