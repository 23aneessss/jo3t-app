import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/follow_suggestions_screen.dart';
import '../../features/auth/presentation/food_preferences_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/wilaya_select_screen.dart';
import '../../features/discovery/presentation/discovery_feed_screen.dart';
import '../../features/discovery/presentation/search_screen.dart';
import '../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/place/presentation/all_reviews_screen.dart';
import '../../features/place/presentation/gallery_screen.dart';
import '../../features/place/presentation/place_profile_screen.dart';
import '../../features/profile/presentation/followers_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/user_profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/saved/presentation/saved_screen.dart';
import '../../features/add_place/presentation/add_place_screen.dart';
import '../../features/review/presentation/write_review_screen.dart';
import '../../features/venue/presentation/claim_venue_screen.dart';
import '../../features/venue/presentation/manage_venue_screen.dart';
import '../../features/venue/presentation/venue_dashboard_screen.dart';
import '../../features/events/presentation/event_detail_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/place/presentation/suggest_edits_screen.dart';
import '../../shared/widgets/main_shell.dart';
import '../constants/app_animations.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Auth flow
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const AuthScreen()),
    ),
    GoRoute(
      path: '/verify-phone',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return _slideUpPage(
          state,
          OtpScreen(
            phone: extra?['phone'] ?? '',
            verificationId: extra?['verificationId'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: '/wilaya-select',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const WilayaSelectScreen()),
    ),
    GoRoute(
      path: '/food-preferences',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const FoodPreferencesScreen()),
    ),
    GoRoute(
      path: '/follow-suggestions',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const FollowSuggestionsScreen()),
    ),

    // Main shell with bottom nav
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/feed',
          pageBuilder: (context, state) =>
              _fadePage(state, const DiscoveryFeedScreen()),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) =>
              _fadePage(state, const SearchScreen()),
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) =>
              _fadePage(state, const MapScreen()),
        ),
        GoRoute(
          path: '/saved',
          pageBuilder: (context, state) =>
              _fadePage(state, const SavedScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _fadePage(state, const ProfileScreen()),
        ),
      ],
    ),

    // Full-screen routes (outside shell)
    GoRoute(
      path: '/add-place',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const AddPlaceScreen()),
    ),
    GoRoute(
      path: '/place/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _slideUpPage(state, PlaceProfileScreen(placeId: id));
      },
    ),
    GoRoute(
      path: '/place/:id/gallery',
      pageBuilder: (context, state) {
        final photos = (state.extra as Map<String, dynamic>?)?['photos'] as List<String>? ?? [];
        final name = (state.extra as Map<String, dynamic>?)?['name'] as String? ?? '';
        final index = (state.extra as Map<String, dynamic>?)?['index'] as int? ?? 0;
        return _slideUpPage(state, GalleryScreen(photos: photos, placeName: name, initialIndex: index));
      },
    ),
    GoRoute(
      path: '/place/:id/reviews',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final id = state.pathParameters['id']!;
        return _slideUpPage(
          state,
          AllReviewsScreen(
            placeId: id,
            placeName: extra['name'] as String? ?? '',
            averageScore: (extra['averageScore'] as num?)?.toDouble() ?? 0,
            reviewCount: extra['reviewCount'] as int? ?? 0,
          ),
        );
      },
    ),
    GoRoute(
      path: '/review/new/:placeId',
      pageBuilder: (context, state) {
        final id = state.pathParameters['placeId']!;
        return _slideUpPage(state, WriteReviewScreen(placeId: id));
      },
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const NotificationsScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const SettingsScreen()),
    ),
    GoRoute(
      path: '/followers',
      pageBuilder: (context, state) {
        final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
        return _slideUpPage(state, FollowersScreen(initialTab: tab));
      },
    ),
    GoRoute(
      path: '/leaderboard',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const LeaderboardScreen()),
    ),
    GoRoute(
      path: '/user/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _slideUpPage(state, UserProfileScreen(userId: id));
      },
    ),
    GoRoute(
      path: '/suggest-edits/:placeId',
      pageBuilder: (context, state) {
        final id = state.pathParameters['placeId']!;
        final name = (state.extra as Map<String, dynamic>?)?['name'] as String? ?? '';
        return _slideUpPage(state, SuggestEditsScreen(placeId: id, placeName: name));
      },
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) =>
          _slideUpPage(state, const EditProfileScreen()),
    ),
    GoRoute(
      path: '/venue-dashboard/:placeId',
      pageBuilder: (context, state) {
        final id = state.pathParameters['placeId']!;
        final name = (state.extra as Map<String, dynamic>?)?['name'] as String? ?? '';
        return _slideUpPage(state, VenueDashboardScreen(placeId: id, placeName: name));
      },
    ),
    GoRoute(
      path: '/manage-venue/:placeId',
      pageBuilder: (context, state) {
        final id = state.pathParameters['placeId']!;
        final name = (state.extra as Map<String, dynamic>?)?['name'] as String? ?? '';
        return _slideUpPage(state, ManageVenueScreen(placeId: id, placeName: name));
      },
    ),
    GoRoute(
      path: '/claim-venue/:placeId',
      pageBuilder: (context, state) {
        final id = state.pathParameters['placeId']!;
        final name = (state.extra as Map<String, dynamic>?)?['name'] as String? ?? '';
        return _slideUpPage(state, ClaimVenueScreen(placeId: id, placeName: name));
      },
    ),
    GoRoute(
      path: '/event/:id',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return _slideUpPage(
          state,
          EventDetailScreen(
            title: extra['title'] as String? ?? '',
            placeName: extra['placeName'] as String? ?? '',
            placeId: extra['placeId'] as String? ?? '',
            date: extra['date'] as String? ?? '',
            imageUrl: extra['imageUrl'] as String? ?? '',
            attendees: extra['attendees'] as int? ?? 0,
            color: Color(extra['colorValue'] as int? ?? 0xFFFF6B35),
            description: extra['description'] as String?,
          ),
        );
      },
    ),
  ],
);

// ---- Transition helpers ----

CustomTransitionPage<void> _slideUpPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.06),
        end: Offset.zero,
      ).animate(
          CurvedAnimation(parent: animation, curve: AppAnimations.enter));
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
