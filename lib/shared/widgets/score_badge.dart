import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

enum ScoreBadgeSize { large, small }

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({
    super.key,
    required this.score,
    this.size = ScoreBadgeSize.large,
    this.animate = false,
    this.delay = Duration.zero,
  });

  final double score;
  final ScoreBadgeSize size;
  final bool animate;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.scoreColor(score);
    final dimension = size == ScoreBadgeSize.large
        ? AppSizes.scoreBadgeLg
        : AppSizes.scoreBadgeSm;
    final fontSize = size == ScoreBadgeSize.large ? 13.0 : 11.0;
    final fontWeight =
        size == ScoreBadgeSize.large ? FontWeight.w700 : FontWeight.w600;

    Widget badge = Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.30), width: 1),
      ),
      child: Center(
        child: Text(
          score.toStringAsFixed(score.truncateToDouble() == score ? 0 : 1),
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: 1,
          ),
        ),
      ),
    );

    if (!animate) return badge;

    return badge
        .animate(delay: delay)
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: AppAnimations.badge,
          curve: AppAnimations.bounce,
        )
        .fadeIn(duration: AppAnimations.fast);
  }
}
