import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.score,
    this.size = 100,
    this.strokeWidth = 7,
    this.delay = Duration.zero,
  });

  final double score;
  final double size;
  final double strokeWidth;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.scoreColor(score);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score / 10),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return CustomPaint(
          size: Size(size, size),
          painter: _RingPainter(
            progress: progress,
            color: color,
            strokeWidth: strokeWidth,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => Text(
                      v.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: size * 0.22,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1,
                      ),
                    ),
                  ),
                  Text(
                    '/10',
                    style: TextStyle(
                      fontSize: size * 0.11,
                      fontWeight: FontWeight.w500,
                      color: color.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Colored arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}
