import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSizes.s16,
                    left: AppSizes.screenHorizontalPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white.withOpacity(0.25),
                          child: const Text(
                            'A',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        )
                            .animate()
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1, 1),
                              duration: AppAnimations.normal,
                              curve: AppAnimations.overshoot,
                            ),
                        const SizedBox(height: AppSizes.s8),
                        const Text(
                          'Anes Bouziani',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate(delay: const Duration(milliseconds: 100))
                            .fadeIn(duration: AppAnimations.normal)
                            .slideX(begin: -0.1, end: 0, duration: AppAnimations.normal),
                        const SizedBox(height: AppSizes.s4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s8, vertical: AppSizes.s4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: const Text(
                            '📍 Blida',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                            .animate(delay: const Duration(milliseconds: 150))
                            .fadeIn(duration: AppAnimations.normal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.screenHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsRow(),
                  const SizedBox(height: AppSizes.s24),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200), duration: AppAnimations.normal),
                  const SizedBox(height: AppSizes.s12),
                  _EmptyReviews(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: '12', label: 'Reviews', delay: 0),
        const SizedBox(width: AppSizes.s16),
        _Stat(value: '48', label: 'Following', delay: 1),
        const SizedBox(width: AppSizes.s16),
        _Stat(value: '23', label: 'Followers', delay: 2),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.delay});

  final String value;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16, vertical: AppSizes.s12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSizes.s2),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    )
        .animate(delay: AppAnimations.staggerDelay * delay)
        .fadeIn(duration: AppAnimations.normal, curve: AppAnimations.enter)
        .slideY(begin: 0.2, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}

class _EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s32),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, size: 48, color: AppColors.neutral300),
            const SizedBox(height: AppSizes.s12),
            Text(
              'No reviews yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.neutral500),
            ),
            const SizedBox(height: AppSizes.s8),
            Text(
              'Start discovering places and share\nyour experience with the community.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 300), duration: AppAnimations.normal)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}
