import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/jo3t_logo.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Rising orange wave
          AnimatedBuilder(
            animation: _waveAnim,
            builder: (context, _) => CustomPaint(
              painter: _WavePainter(
                progress: _waveAnim.value,
                color: AppColors.primary,
              ),
            ),
          ),

          // A single centred lockup that recolours orange→white as the wave
          // sweeps over it — one element, so nothing overlaps or shows through.
          Center(
            child: AnimatedBuilder(
              animation: _waveAnim,
              builder: (context, _) {
                final cover = ((_waveAnim.value - 0.48) / 0.30).clamp(0.0, 1.0);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 1 - cover,
                      child: const _SplashLockup(onDark: false),
                    ),
                    Opacity(
                      opacity: cover,
                      child: const _SplashLockup(onDark: true),
                    ),
                  ],
                );
              },
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  duration: AppAnimations.slow,
                  curve: AppAnimations.overshoot,
                ),
          ),
        ],
      ),
    );
  }
}

/// The full splash lockup — mark, Arabic logotype, JO3T, tagline.
/// Rendered twice (orange-on-white, then white-on-orange) and cross-faded so
/// the wave appears to recolour it.
class _SplashLockup extends StatelessWidget {
  const _SplashLockup({required this.onDark});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final brand = onDark ? Colors.white : AppColors.primary;
    final latin = onDark ? Colors.white : AppColors.neutral900;
    final tagline =
        onDark ? Colors.white.withValues(alpha: 0.85) : AppColors.neutral500;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Jo3tMark(size: 56, color: brand),
        const SizedBox(height: 24),
        Jo3tWordmark(fontSize: 84, color: brand),
        // Generous gap so the descender of "جعت" never touches the line below.
        const SizedBox(height: 30),
        Text(
          'JO3T',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: latin,
            letterSpacing: 11,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Algeria's food community",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: tagline,
            letterSpacing: 0.5,
          ),
        ),
      ],
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
