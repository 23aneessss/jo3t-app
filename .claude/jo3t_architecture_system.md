# JO3T — Architecture System
> Version 1.0 | Flutter + Firebase + Google Maps

---

## 1. Overview

JO3T is a Flutter mobile application (Android-first, iOS at Phase 3) backed by Firebase for backend services and the Google Maps SDK for geo features. The architecture is designed to be:

- **Scalable**: From 100 to 100,000 users without a rewrite
- **Offline-capable**: Core browsing works without internet
- **Maintainable**: Clean separation of concerns, testable at each layer
- **Cost-aware**: Firebase free tier covers MVP; pricing predictable beyond it

---

## 2. High-Level Architecture

```
┌─────────────────────────────────────────────┐
│              Flutter App (Client)            │
│                                             │
│  Presentation Layer   ←→   State Layer       │
│  (Screens + Widgets)       (Riverpod)        │
│           ↕                    ↕             │
│        Domain Layer (Use Cases / Entities)   │
│           ↕                                  │
│        Data Layer (Repositories)             │
│           ↕                                  │
└─────────────────────────────────────────────┘
              ↕              ↕          ↕
        Firebase         Google     Algolia
        (Backend)        Maps SDK   (Search)
```

---

## 3. Flutter App Architecture

### Pattern: Clean Architecture + Riverpod

Layers from inside-out:

1. **Domain** — pure Dart, no Flutter imports
   - Entities (Place, Review, User, Wilaya)
   - Repository interfaces (abstract)
   - Use cases (GetNearbyPlaces, SubmitReview, etc.)

2. **Data** — implements domain interfaces
   - Firebase repositories (Firestore, Storage, Auth)
   - Local repositories (Hive for caching)
   - DTOs and mappers

3. **Presentation** — Flutter widgets and screens
   - Screens (stateless where possible)
   - State managed by Riverpod providers
   - No business logic in widgets

### Folder Structure

```
lib/
├── core/
│   ├── constants/         # App-wide constants (colors, strings, sizes)
│   ├── errors/            # Failure types, exceptions
│   ├── extensions/        # Dart extensions
│   ├── router/            # GoRouter configuration
│   ├── theme/             # ThemeData, TextStyles, ColorScheme
│   └── utils/             # Formatters, validators, helpers
│
├── features/
│   ├── auth/
│   │   ├── data/          # FirebaseAuth repository implementation
│   │   ├── domain/        # Auth entities, interfaces, use cases
│   │   └── presentation/  # Login screen, onboarding screens
│   │
│   ├── discovery/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/  # Home feed, search screen
│   │
│   ├── place/
│   │   ├── data/
│   │   ├── domain/        # Place entity, PlaceRepository interface
│   │   └── presentation/  # Place profile, gallery, review list
│   │
│   ├── map/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/  # Map screen, place pins, bottom sheets
│   │
│   ├── review/
│   │   ├── data/
│   │   ├── domain/        # Review entity, submit use case
│   │   └── presentation/  # Review form, photo upload
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/  # User profile, saved places, lists
│   │
│   └── add_place/
│       ├── data/
│       ├── domain/
│       └── presentation/  # Add place form, submission flow
│
├── shared/
│   ├── widgets/           # Reusable components (PlaceCard, ScoreBadge, etc.)
│   ├── providers/         # Shared Riverpod providers
│   └── models/            # Shared data models
│
└── main.dart
```

---

## 4. State Management: Riverpod

**Why Riverpod over Bloc or Provider:**
- No BuildContext required to read state
- Compile-time safety
- Easy to test
- Natural fit with async/streams from Firebase

### Provider Types Used

| Provider type | When to use |
|---|---|
| `Provider` | Static values, theme, router |
| `FutureProvider` | One-time async fetches (place detail) |
| `StreamProvider` | Real-time Firestore streams (feed, notifications) |
| `StateNotifierProvider` | Complex mutable state (form state, filters) |
| `AsyncNotifierProvider` | Async operations with loading/error/data states |

### Example: Nearby Places

```dart
// domain/repositories/place_repository.dart
abstract class PlaceRepository {
  Stream<List<Place>> getNearbyPlaces({
    required String wilayadId,
    required PlaceCategory? category,
    required int limit,
  });
}

// presentation/providers/discovery_provider.dart
@riverpod
Stream<List<Place>> nearbyPlaces(NearbyPlacesRef ref) {
  final repo = ref.watch(placeRepositoryProvider);
  final filters = ref.watch(discoveryFiltersProvider);
  return repo.getNearbyPlaces(
    wilayaId: filters.wilayaId,
    category: filters.category,
    limit: 20,
  );
}
```

---

## 5. Navigation: GoRouter

Single-source navigation, URL-based, supports deep linking.

### Route Structure

```
/                        → SplashScreen
/onboarding              → OnboardingScreen
/auth                    → AuthScreen
/home                    → HomeShell (bottom nav)
  /home/feed             → DiscoveryFeedScreen
  /home/map              → MapScreen
  /home/add              → AddPlaceScreen
  /home/saved            → SavedPlacesScreen
  /home/profile          → ProfileScreen
/place/:id               → PlaceProfileScreen
  /place/:id/gallery     → GalleryScreen
  /place/:id/reviews     → AllReviewsScreen
/review/new/:placeId     → WriteReviewScreen
/user/:id                → PublicProfileScreen
/settings                → SettingsScreen
```

### Transitions

- Push → `CustomTransitionPage` with slide-up + fade
- Pop → reverse
- Tab switch → `FadeTransition` (no slide)
- `OpenContainer` from `animations` package for card → detail

---

## 6. Backend: Firebase

### Services Used

| Service | Purpose |
|---|---|
| Firebase Auth | Google Sign-In + Phone auth |
| Firestore | Main database |
| Firebase Storage | Photo uploads |
| Firebase Functions | Moderation queue, JO3T score calculation |
| Firebase App Check | Prevent API abuse |
| Crashlytics | Crash reporting |
| Analytics | User behavior tracking |

### Firestore Data Model

```
/users/{userId}
  - displayName: string
  - avatarUrl: string
  - wilayaId: string
  - bio: string
  - createdAt: timestamp
  - followersCount: number
  - followingCount: number
  - reviewsCount: number

/users/{userId}/savedPlaces/{placeId}
  - savedAt: timestamp

/users/{userId}/following/{targetUserId}
  - followedAt: timestamp

/places/{placeId}
  - name: string
  - category: enum (restaurant|cafe|patisserie|sandwich|street_food|juice)
  - wilayaId: string
  - neighborhood: string
  - address: string
  - geo: GeoPoint
  - coverPhotoUrl: string
  - photos: string[]
  - averageScore: number (1–10, float)
  - reviewCount: number
  - jo3tScore: number (computed by Cloud Function)
  - priceRange: enum (budget|mid|premium)
  - status: enum (pending|active|flagged|closed)
  - addedBy: userId
  - createdAt: timestamp
  - updatedAt: timestamp
  - isVerified: boolean (owner claimed)

/reviews/{reviewId}
  - placeId: string
  - authorId: string
  - score: number (1–10)
  - text: string
  - photos: string[]
  - likesCount: number
  - flagsCount: number
  - createdAt: timestamp
  - updatedAt: timestamp

/wilayas/{wilayaId}
  - name_fr: string
  - name_ar: string
  - code: string (01–48)
  - centerGeo: GeoPoint
  - topPlaces: string[] (top 10 placeIds, updated weekly)
```

### Firestore Indexes Required

- `places` by `wilayaId` + `category` + `jo3tScore DESC`
- `places` by `wilayaId` + `jo3tScore DESC`
- `reviews` by `placeId` + `createdAt DESC`
- `reviews` by `authorId` + `createdAt DESC`

### Security Rules (summary)

```
- Any authenticated user can read places and reviews
- Users can only write their own reviews (userId == request.auth.uid)
- Places require authentication to submit (status = "pending")
- Only Cloud Functions can write jo3tScore, averageScore, reviewCount
- Admin SDK (Functions) bypasses rules for moderation
```

---

## 7. Search: Algolia

Firestore alone doesn't support full-text search. Algolia (free tier: 10k searches/month) is synced via Cloud Functions.

**What's indexed:**
- Place name
- Category
- Wilaya
- Neighborhood
- Tags (added by community)

**Sync trigger:** Firestore `onCreate` and `onUpdate` on `/places/{id}` → Cloud Function → Algolia index update

**Flutter package:** `algolia_helper_flutter`

---

## 8. Google Maps Integration

**Package:** `google_maps_flutter` (official)

### Configuration

- Restrict Maps API key to Android app package name + SHA-1
- Enable: Maps SDK for Android, Places API, Geocoding API
- Budget alert set at $20/month in Google Cloud Console

### Features Implemented

| Feature | Implementation |
|---|---|
| Map display | `GoogleMap` widget with custom tile styling (warm, desaturated) |
| Place markers | Custom `BitmapDescriptor` from SVG → PNG conversion |
| Marker clustering | `google_maps_cluster_manager` package |
| Current location | `geolocator` package + permission_handler |
| Geocoding address | Places API on place submission form |
| Deep link to navigation | `maps_launcher` package (opens Google Maps or Waze) |

### Map Style

Use a custom JSON style to desaturate and warm the base map, matching JO3T's color palette. Roads in neutral.200, water in a light blue-gray, greenery muted. Labels in neutral.700. Orange is reserved exclusively for JO3T pins.

---

## 9. Local Storage & Caching

**Package:** `hive_flutter` (lightweight, fast, no native dependencies)

| What's cached | Key | TTL |
|---|---|---|
| Current user profile | `user_profile` | Until logout |
| Saved places list | `saved_places` | 24 hours |
| Last wilaya feed | `feed_{wilayaId}` | 2 hours |
| Viewed place details | `place_{id}` | 6 hours |
| Map pins for wilaya | `map_{wilayaId}` | 1 hour |

Firestore `QuerySnapshot` is also automatically cached by the SDK (offline persistence enabled).

---

## 10. Photo Upload Flow

```
User selects image (image_picker)
  → Compress to max 1MB (flutter_image_compress)
  → Generate local preview immediately (show in UI)
  → Upload to Firebase Storage (/places/{id}/photos/{uuid}.jpg)
  → On success: update Firestore place.photos array
  → On failure: retry up to 3 times, then show error
```

Storage rules:
- Authenticated users only
- Max file size: 5MB (enforced at Storage level)
- Allowed MIME types: image/jpeg, image/png, image/webp

---

## 11. Key Flutter Packages

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.x | State management |
| `riverpod_annotation` | ^2.x | Code generation for providers |
| `go_router` | ^13.x | Navigation |
| `firebase_core` | latest | Firebase init |
| `firebase_auth` | latest | Authentication |
| `cloud_firestore` | latest | Database |
| `firebase_storage` | latest | File uploads |
| `google_maps_flutter` | latest | Map |
| `geolocator` | latest | GPS location |
| `permission_handler` | latest | Runtime permissions |
| `image_picker` | latest | Camera/gallery |
| `flutter_image_compress` | latest | Image compression |
| `hive_flutter` | latest | Local cache |
| `algolia_helper_flutter` | latest | Search |
| `animations` | latest | Page transitions |
| `flutter_animate` | latest | Widget animations |
| `shimmer` | latest | Skeleton loading |
| `lottie` | latest | Lottie animations |
| `cached_network_image` | latest | Image caching |
| `timeago` | latest | "2 hours ago" format |
| `intl` | latest | Date/number formatting |
| `google_sign_in` | latest | Google auth |
| `maps_launcher` | latest | Open in Google Maps |
| `share_plus` | latest | Share places |
| `url_launcher` | latest | External links |
| `package_info_plus` | latest | App version |
| `connectivity_plus` | latest | Network status |
| `flutter_native_splash` | latest | Splash screen |
| `google_fonts` | latest | Plus Jakarta Sans |

---

## 12. CI/CD

### Tools
- **GitHub Actions** for CI
- **Fastlane** for Android deployment to Play Store
- **Firebase App Distribution** for beta builds

### Pipeline

```
Push to main branch
  → Run flutter analyze
  → Run flutter test
  → Build APK (release)
  → Upload to Firebase App Distribution (beta testers)

Tag release (v1.x.x)
  → Build App Bundle (AAB)
  → Upload to Google Play (internal track)
  → Promote to production manually
```

---

## 13. Environment Configuration

Three environments, managed via `--dart-define`:

| Environment | Firebase Project | Purpose |
|---|---|---|
| `dev` | `jo3t-dev` | Local development |
| `staging` | `jo3t-staging` | QA + beta testing |
| `production` | `jo3t-prod` | Live users |

Each environment has its own `google-services.json` and Maps API key.

---

## 14. Performance Targets

| Metric | Target |
|---|---|
| Cold start time (Android mid-range) | < 2.5 seconds |
| Home feed load (first paint) | < 1.5 seconds |
| Place detail open (with hero) | < 300ms perceived |
| Image load (cached) | < 100ms |
| Search results | < 500ms |
| Map pin render (100 pins) | < 500ms |
| APK size | < 25MB |

---

*Architecture decisions are final until a documented ADR (Architecture Decision Record) overrides them.*
