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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  late final Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _waveAnim = CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOutCubic,
    );

    // Logo appears first, then wave rises
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _waveController.forward();
    });

    // Navigate when wave fully covers screen
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Rising wave
          AnimatedBuilder(
            animation: _waveAnim,
            builder: (context, _) => CustomPaint(
              painter: _WavePainter(
                progress: _waveAnim.value,
                color: AppColors.primary,
              ),
            ),
          ),

          // Logo — stays in upper zone, never covered
          Positioned(
            top: size.height * 0.32,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Arabic logotype
                Text(
                  'جعت',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1,
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter,
                    )
                    .scale(
                      begin: const Offset(0.85, 0.85),
                      end: const Offset(1, 1),
                      duration: AppAnimations.medium,
                      curve: AppAnimations.overshoot,
                    ),

                const SizedBox(height: 12),

                // Latin wordmark
                Text(
                  'JO3T',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                    letterSpacing: 10,
                  ),
                )
                    .animate(delay: const Duration(milliseconds: 150))
                    .fadeIn(duration: AppAnimations.normal)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter,
                    ),

                const SizedBox(height: 10),

                Text(
                  "Algeria's food community",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutral500,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate(delay: const Duration(milliseconds: 280))
                    .fadeIn(duration: AppAnimations.normal),
              ],
            ),
          ),

          // Wave text — "JO3T" appears in white as wave rises
          AnimatedBuilder(
            animation: _waveAnim,
            builder: (context, _) {
              final opacity = ((_waveAnim.value - 0.6) / 0.4).clamp(0.0, 1.0);
              return Opacity(
                opacity: opacity,
                child: Align(
                  alignment: const Alignment(0, 0.1),
                  child: Text(
                    'جعت',
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()..color = color;
    const domeHeight = 56.0;

    // Wave top center Y — rises from bottom to top
    final waveTopY = size.height - (size.height * 1.02 * progress);

    final path = Path();
    // Left edge start (below dome)
    path.moveTo(-30, waveTopY + domeHeight);
    // Smooth dome across the top using cubic bezier
    path.cubicTo(
      size.width * 0.20, waveTopY - domeHeight,   // left rise
      size.width * 0.80, waveTopY - domeHeight,   // right rise
      size.width + 30, waveTopY + domeHeight,      // right edge
    );
    path.lineTo(size.width + 30, size.height + 10);
    path.lineTo(-30, size.height + 10);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.progress != progress;
}
