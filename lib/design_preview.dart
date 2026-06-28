// TEMPORARY design-verification screen — delete after review.
import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/presentation/widgets/onboarding_art.dart';
import 'shared/widgets/jo3t_logo.dart';

class DesignPreview extends StatelessWidget {
  const DesignPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Jo3tLogo(),
              const Divider(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.scale(scale: 0.55, child: const DiscoverArt()),
                  Transform.scale(scale: 0.55, child: const ReviewsArt()),
                ],
              ),
              Transform.scale(scale: 0.7, child: const WilayaArt()),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(t,
            style: const TextStyle(
                color: AppColors.neutral300,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      );
}
