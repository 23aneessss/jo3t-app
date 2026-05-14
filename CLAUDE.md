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
- [x] `animations` package (SharedAxis, OpenContainer, FadeThrough) — FadeThroughTransition on tab switch, SharedAxisTransition on add-place steps
- [x] `shimmer` for skeleton loaders
- [ ] `lottie` for splash + empty states
- [x] Global animation constants (durations, curves) → `app_animations.dart`
- [x] Page transition system (fade push, fade tab switch)
- [x] Place card entry animation (fade up, translateY 12→0, stagger)
- [x] Score badge entry animation (scale 0→1 + fade, elasticOut bounce)
- [x] Card press feedback (scale 0.98, 80ms)
- [x] Bottom sheet slide-up animation (`showJo3tBottomSheet` helper)
- [x] Map pin tap scale animation (AnimatedScale 1→1.25 + pulse ring on selected)
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
- [x] Phone OTP verification screen — 6-box input, blinking cursor, resend timer, success animation
- [x] Wilaya selection screen — searchable list, animated tiles, check icon toggle
- [x] Food preferences screen — 3×4 grid, emoji cards, selection progress bar
- [x] Follow suggestions screen — user cards, animated Follow toggle, "Start exploring" CTA

### Discovery Feature
- [x] Home feed screen (animated app bar, category chips, place cards, skeleton loading)
- [x] Category filter chips (horizontal scroll, animated stagger, filters feed)
- [x] Wilaya filter bottom sheet (tappable title → modal, 10 top wilayas, "Near me" option)
- [x] Notification bell in feed AppBar → `/notifications` route
- [x] Search screen — category grid + trending section, live search with debounce, animated results
- [x] Search results list (animated entry, open/closed status, distance, navigates to place profile)

### Place Feature
- [x] Place profile screen — SliverAppBar hero, score badge, quick info row
- [x] Cover image + gallery strip (staggered scale animation)
- [x] Score display (large animated ScoreBadge)
- [x] Review list (3 ReviewCards with stagger)
- [x] Address + Directions action button
- [x] Opening hours / Open-Closed status
- [x] Price range indicator
- [x] Save to list button (animated toggle bookmark)
- [x] Similar places horizontal scroll (filtered by category, animated entry, tappable)

### Map Feature
- [ ] Map screen with Google Maps (pending Firebase/Maps SDK setup)
- [x] Custom place pins (category icon, selected label bubble, pulse ring)
- [ ] Marker clustering
- [x] Bottom sheet preview on pin tap (place card with cover + score + open status + navigate)
- [ ] "Near me" mode

### Review Feature
- [x] Write review screen
- [x] 1–10 score picker (animated circle buttons, color by score)
- [ ] Photo upload (image_picker + compress — UI shell done)
- [x] Review submission flow (mock delay + SnackBar confirmation)

### Profile Feature
- [x] User profile screen — premium gradient header, achievement badges, tappable stat cards
- [x] Saved tab as 2-column photo grid (image-fill cards, bookmark icon, score overlay)
- [x] Wilaya badge on profile
- [x] Reviewed places list — compact place rows with user score, review snippet, time ago
- [x] Want-to-try list — wishlist tab with Visited + Remove actions
- [x] Followers / Following screen

### Add Place Feature
- [x] Add place form — multi-step with animated progress bar
- [x] Category selector — emoji grid with scale/color selection animation
- [x] Wilaya + neighborhood selector — quick-pick chips + AppTextField
- [ ] Address autocomplete (Places API — pending Firebase setup)
- [x] Photo upload UI (shell done, image_picker pending Firebase)
- [x] Submission confirmation — SnackBar + 24h moderation info

---

## Phase 2 — Social Layer (Months 4–6)

- [x] Follow / Unfollow system — UI toggle in Want-to-try + Follow suggestions
- [x] Activity feed ("Amine reviewed Chez Fatima · Blida · 8.5") — "Following" tab in discovery feed
- [x] Mutual recommendations ("3 people you follow liked this") — section in place profile
- [x] Collections / curated lists — Create collection bottom sheet in Saved screen
- [ ] Share list as link (requires Firebase Dynamic Links)
- [x] Wilaya leaderboard (top 10, weekly) — `/leaderboard` route, This Week / All Time toggle
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

### Notifications Feature (Phase 2 — started)
- [x] Notifications screen — unread dot, read/unread state, type badges (review/follow/place/weekly)
- [x] Mark all read action + individual mark as read on tap
- [x] Notification type filter chips (All / Reviews / Follows / Places / Weekly)
- [ ] Real push notifications (Firebase Cloud Messaging)

### Search Feature (enhanced)
- [x] People tab — search/discover users with Follow toggle + mutual connections count
- [x] Suggested users explore state + filtered search results

### Discovery Feed (enhanced)
- [x] "For You" / "Following" tab toggle with animated pill switcher
- [x] Following feed — activity cards (review/follow/new_place/save) with avatars + place thumbnails
- [x] Explore by Wilaya — horizontal gradient cards with place counts, tap to filter feed
- [x] Leaderboard CTA in Top Rated section header

### Place Profile (enhanced)
- [x] Mutual recommendations section — "Friends who know this place" with stacked avatars + friend review snippet
- [x] Share sheet — Copy link, WhatsApp, Instagram, Messenger with animated icons + "Copied!" feedback

### Profile (enhanced)
- [x] Share profile sheet — avatar preview + copy link / WhatsApp / Instagram / QR code

### Leaderboard Feature
- [x] Leaderboard screen — `/leaderboard` route, This Week / All Time toggle
- [x] Top 3 podium cards (gold/silver/bronze) with shadow highlights
- [x] Ranks 4-10 list with trend indicators (+/- %)

### Saved Screen (enhanced)
- [x] Create Collection bottom sheet — name input + icon picker (8 icons) + animated create button

### Place Profile (further enhanced)
- [x] Check-In button in quick actions — animated toggle, SnackBar confirmation, "Visited!" state
- [x] Share button wired to share sheet

### Events Feature
- [x] Events section in discovery feed — horizontal scroll of event cards (title, date chip, attendees count, place image)

### User Profile Feature (Phase 2)
- [x] User profile screen `/user/:id` — gradient header, avatar, follow button, stats row, reviews list
- [x] Mock user data for: amine, sara, nadia, karim, mohamed
- [x] Avatar tappable from: activity feed cards, People search results → navigates to `/user/:id`

---

*Last updated: 2026-05-14 (Phase 2 social layer substantially complete)*
