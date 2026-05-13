import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.neutral100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 64, color: AppColors.neutral300),
                  const SizedBox(height: AppSizes.s12),
                  Text(
                    'Map coming soon',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.neutral500,
                        ),
                  ),
                  const SizedBox(height: AppSizes.s8),
                  Text(
                    'Google Maps SDK integration pending\nFirebase setup',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),
            ),
          ),
          Positioned(
            bottom: AppSizes.s24,
            right: AppSizes.s16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.my_location, color: Colors.white),
            )
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  delay: const Duration(milliseconds: 200),
                  duration: AppAnimations.normal,
                  curve: AppAnimations.overshoot,
                ),
          ),
        ],
      ),
    );
  }
}
