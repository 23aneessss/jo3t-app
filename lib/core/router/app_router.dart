import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/discovery/presentation/discovery_feed_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../shared/widgets/main_shell.dart';
import '../constants/app_animations.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/feed',
          pageBuilder: (context, state) =>
              _fadePage(state, const DiscoveryFeedScreen()),
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) =>
              _fadePage(state, const MapScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _fadePage(state, const ProfileScreen()),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _slideUpPage(
    GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.06),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.enter,
      ));
      return SlideTransition(
        position: slideAnimation,
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
