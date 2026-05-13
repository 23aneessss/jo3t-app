import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkDivider : AppColors.neutral100,
      highlightColor: isDark ? const Color(0xFF3A3A3A) : AppColors.neutral50,
      child: child,
    );
  }
}

class PlaceCardSkeleton extends StatelessWidget {
  const PlaceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding,
          vertical: AppSizes.s4,
        ),
        padding: const EdgeInsets.all(AppSizes.s12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.placeCardImageSize,
              height: AppSizes.placeCardImageSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(height: 16, widthFraction: 0.7),
                  const SizedBox(height: AppSizes.s8),
                  _bar(height: 12, widthFraction: 0.5),
                  const SizedBox(height: AppSizes.s12),
                  _bar(height: 28, widthFraction: 0.18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar({required double height, required double widthFraction}) {
    return FractionallySizedBox(
      widthFactor: widthFraction,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}
