import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.stateChange,
        height: AppSizes.chipHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: selected
                ? AppColors.primary.withOpacity(0.20)
                : AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: Icon(
                icon,
                key: ValueKey(selected),
                size: AppSizes.iconChip,
                color: selected ? AppColors.primary : AppColors.neutral500,
              ),
            ),
            const SizedBox(width: AppSizes.s4),
            AnimatedDefaultTextStyle(
              duration: AppAnimations.fast,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.neutral700,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    )
        .animate(delay: animationDelay)
        .fadeIn(duration: AppAnimations.normal, curve: AppAnimations.enter)
        .slideX(
          begin: 0.1,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}
