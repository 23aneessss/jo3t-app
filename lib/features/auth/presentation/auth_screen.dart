import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.s48),

              // Header
              Text(
                'جعت',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1,
                ),
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s16),

              Text(
                'Join Algeria\'s\nfood community.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: AppColors.neutral900,
                    ),
              )
                  .animate(delay: const Duration(milliseconds: 80))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s8),

              Text(
                'Discover real places, read honest reviews,\nand share your favorites.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
                  .animate(delay: const Duration(milliseconds: 140))
                  .fadeIn(duration: AppAnimations.normal),

              const Spacer(),

              // Auth options
              _SocialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                iconColor: const Color(0xFF4285F4),
                onTap: () => context.go('/wilaya-select'),
              )
                  .animate(delay: const Duration(milliseconds: 200))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s12),

              _SocialButton(
                label: 'Continue with phone',
                icon: Icons.phone_outlined,
                iconColor: AppColors.neutral700,
                onTap: () => context.go('/wilaya-select'),
              )
                  .animate(delay: const Duration(milliseconds: 260))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s16),

              // Guest mode
              Center(
                child: TextButton(
                  onPressed: () => context.go('/feed'),
                  child: Text(
                    'Browse as guest',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  .animate(delay: const Duration(milliseconds: 320))
                  .fadeIn(duration: AppAnimations.normal),

              const SizedBox(height: AppSizes.s24),

              // Legal
              Center(
                child: Text(
                  'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.neutral300,
                    height: 1.6,
                  ),
                ),
              )
                  .animate(delay: const Duration(milliseconds: 360))
                  .fadeIn(duration: AppAnimations.normal),

              const SizedBox(height: AppSizes.s16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? AppAnimations.cardPressScale : 1.0,
        duration: AppAnimations.micro,
        curve: AppAnimations.stateChange,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            color: _pressed ? AppColors.neutral100 : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.neutral200, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 24),
              const SizedBox(width: AppSizes.s12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
