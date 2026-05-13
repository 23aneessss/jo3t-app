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
import '../../features/map/presentation/map_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/place/presentation/place_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/saved/presentation/saved_screen.dart';
import '../../features/add_place/presentation/add_place_screen.dart';
import '../../features/review/presentation/write_review_screen.dart';
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
      pageBuilder: (context, state) =>
          _slideUpPage(state, const OtpScreen()),
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
