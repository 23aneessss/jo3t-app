import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) context.go('/feed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'جعت',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1, 1),
                  duration: const Duration(milliseconds: 600),
                  curve: AppAnimations.overshoot,
                )
                .fadeIn(duration: const Duration(milliseconds: 400)),
            const SizedBox(height: 12),
            Text(
              'JO3T',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.80),
                letterSpacing: 8,
              ),
            )
                .animate(delay: const Duration(milliseconds: 200))
                .fadeIn(duration: AppAnimations.normal)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),
            const SizedBox(height: 8),
            Text(
              'Algeria\'s food community',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.60),
                letterSpacing: 1,
              ),
            )
                .animate(delay: const Duration(milliseconds: 400))
                .fadeIn(duration: AppAnimations.normal),
          ],
        ),
      ),
    );
  }
}
