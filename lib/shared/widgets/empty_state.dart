import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: iconColor ?? AppColors.primary,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(
                  begin: 1.0,
                  end: 1.06,
                  duration: 1800.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: AppSizes.s20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.neutral900,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideY(begin: 0.1, end: 0),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.s8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.neutral500,
                  fontSize: 14,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.s24),
              PrimaryButton(
                label: actionLabel!,
                onTap: onAction!,
                width: 180,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// Preset empty states used across the app
class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key, required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: 'No results for "$query"',
      subtitle: 'Try a different name, neighborhood, or category.',
      iconColor: AppColors.neutral500,
    );
  }
}

class EmptyFeedState extends StatelessWidget {
  const EmptyFeedState({super.key, required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.restaurant_menu_rounded,
      title: 'Nothing here yet',
      subtitle: 'Follow people to see their activity, or explore places near you.',
      actionLabel: 'Explore places',
      onAction: onExplore,
    );
  }
}

class EmptySavedState extends StatelessWidget {
  const EmptySavedState({super.key, required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.bookmark_border_rounded,
      title: 'No saved places yet',
      subtitle: 'Bookmark places you want to try, then find them here.',
      actionLabel: 'Discover places',
      onAction: onExplore,
    );
  }
}

class EmptyNotificationsState extends StatelessWidget {
  const EmptyNotificationsState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.notifications_none_rounded,
      title: 'All caught up',
      subtitle: 'You\'ll see reviews, follows, and weekly digests here.',
      iconColor: AppColors.neutral500,
    );
  }
}

class EmptyReviewsState extends StatelessWidget {
  const EmptyReviewsState({super.key, required this.onWrite});
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.rate_review_outlined,
      title: 'Be the first to review',
      subtitle: 'Share your experience and help the community.',
      actionLabel: 'Write a review',
      onAction: onWrite,
    );
  }
}
