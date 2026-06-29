import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jo3t_logo.dart';

/// Hand-composed, gently animated onboarding illustrations — no emojis, no
/// stock art. Each is built from the brand palette and the JO3T mark so the
/// three screens feel like one designed set, while staying visually distinct.

const double _kArt = 232;

// ─────────────────────────────────────────────────────────────────────────
// Page 1 — Discover real places.
// The JO3T pin at the centre of a living radar: places orbit, a sonar pings.
// ─────────────────────────────────────────────────────────────────────────
class DiscoverArt extends StatefulWidget {
  const DiscoverArt({super.key});

  @override
  State<DiscoverArt> createState() => _DiscoverArtState();
}

class _DiscoverArtState extends State<DiscoverArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 14))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, __) => CustomPaint(
              size: const Size(_kArt, _kArt),
              painter: _DiscoverPainter(_c.value),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Jo3tMark(size: 58),
          ),
        ],
      ),
    );
  }
}

class _DiscoverPainter extends CustomPainter {
  _DiscoverPainter(this.t);
  final double t; // 0..1 looping

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);

    // Soft brand backdrop
    canvas.drawCircle(c, 108, Paint()..color = AppColors.primaryLight);

    // Static guide rings
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = AppColors.primary.withValues(alpha: 0.16);
    canvas.drawCircle(c, 64, ring);
    canvas.drawCircle(c, 96, ring);

    // Sonar ping — two expanding rings, offset in phase, fading as they grow.
    for (final phase in [0.0, 0.5]) {
      final p = (t + phase) % 1.0;
      final r = 26 + p * 84;
      final a = (1 - p) * 0.35;
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = AppColors.primary.withValues(alpha: a),
      );
    }

    // Places slowly orbiting the pin (radius, base angle in turns).
    final orbit = t * 2 * math.pi;
    final dot = Paint()..color = AppColors.primary;
    final halo = Paint()..color = AppColors.primary.withValues(alpha: 0.16);
    const places = [
      [64.0, 0.05],
      [96.0, 0.42],
      [64.0, 0.70],
      [96.0, 0.88],
    ];
    for (final place in places) {
      final angle = orbit + place[1] * 2 * math.pi;
      final pos = Offset(
        c.dx + place[0] * math.cos(angle),
        c.dy + place[0] * math.sin(angle),
      );
      canvas.drawCircle(pos, 11, halo);
      canvas.drawCircle(pos, 5, dot);
      canvas.drawCircle(pos, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_DiscoverPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────────────────────────
// Page 2 — Honest community reviews.
// Two overlapping review cards that gently float in counter-phase.
// ─────────────────────────────────────────────────────────────────────────
class ReviewsArt extends StatefulWidget {
  const ReviewsArt({super.key});

  @override
  State<ReviewsArt> createState() => _ReviewsArtState();
}

class _ReviewsArtState extends State<ReviewsArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final w = math.sin(_c.value * 2 * math.pi);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                  size: const Size(_kArt, _kArt), painter: _BackdropPainter()),
              // Back card — floats up as the front floats down.
              Transform.translate(
                offset: Offset(28, -36 - w * 5),
                child: Transform.rotate(
                  angle: 0.10 + w * 0.015,
                  child: _reviewCard(width: 150, faded: true),
                ),
              ),
              // Front card — counter-phase.
              Transform.translate(
                offset: Offset(-14, 26 + w * 5),
                child: Transform.rotate(
                  angle: -0.05 - w * 0.015,
                  child: _reviewCard(width: 168, faded: false),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _reviewCard({required double width, required bool faded}) {
    return Opacity(
      opacity: faded ? 0.6 : 1,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person,
                      size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 52, height: 7, color: AppColors.neutral100),
                    const SizedBox(height: 5),
                    Container(
                        width: 34, height: 6, color: AppColors.neutral50),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('8.5',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.star_rounded,
                      size: 14, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                width: double.infinity, height: 6, color: AppColors.neutral100),
            const SizedBox(height: 6),
            Container(width: width * 0.6, height: 6, color: AppColors.neutral50),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Page 3 — Your wilaya, your feed.
// A stylised map tile (grid + scattered mini-pins) with a breathing highlight
// under the chosen place — deliberately different from the radar on page 1.
// ─────────────────────────────────────────────────────────────────────────
class WilayaArt extends StatefulWidget {
  const WilayaArt({super.key});

  @override
  State<WilayaArt> createState() => _WilayaArtState();
}

class _WilayaArtState extends State<WilayaArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, __) => CustomPaint(
              size: const Size(_kArt, _kArt),
              painter: _WilayaPainter(_c.value),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Jo3tMark(size: 50),
          ),
        ],
      ),
    );
  }
}

class _WilayaPainter extends CustomPainter {
  _WilayaPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final w = math.sin(t * 2 * math.pi);

    // Soft brand backdrop (shared with the set)
    canvas.drawCircle(c, 108, Paint()..color = AppColors.primaryLight);

    // Stylised map region (soft blob)
    final region = Path()
      ..moveTo(c.dx - 74, c.dy - 24)
      ..cubicTo(c.dx - 44, c.dy - 76, c.dx + 38, c.dy - 72, c.dx + 66, c.dy - 30)
      ..cubicTo(c.dx + 92, c.dy + 4, c.dx + 54, c.dy + 66, c.dx + 8, c.dy + 74)
      ..cubicTo(c.dx - 46, c.dy + 82, c.dx - 96, c.dy + 24, c.dx - 74, c.dy - 24)
      ..close();
    canvas.drawPath(
        region, Paint()..color = AppColors.primary.withValues(alpha: 0.08));

    // Map grid — dotted graticule clipped to the region (the "map" texture).
    canvas.save();
    canvas.clipPath(region);
    final grid = Paint()..color = AppColors.primary.withValues(alpha: 0.12);
    for (double x = c.dx - 96; x <= c.dx + 96; x += 15) {
      for (double y = c.dy - 96; y <= c.dy + 96; y += 15) {
        canvas.drawCircle(Offset(x, y), 1.1, grid);
      }
    }
    // A couple of soft "roads" sweeping across the region.
    final road = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary.withValues(alpha: 0.14);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 90, c.dy + 10)
        ..cubicTo(c.dx - 30, c.dy - 20, c.dx + 30, c.dy + 40, c.dx + 92, c.dy - 4),
      road,
    );
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 20, c.dy - 78)
        ..cubicTo(c.dx - 6, c.dy - 20, c.dx + 10, c.dy + 20, c.dx + 2, c.dy + 78),
      road,
    );
    canvas.restore();

    // Region outline on top of the texture.
    canvas.drawPath(
      region,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = AppColors.primary.withValues(alpha: 0.28),
    );

    // Breathing highlight under the chosen place.
    final glowR = 32 + w * 4;
    canvas.drawCircle(
      Offset(c.dx, c.dy + 6),
      glowR,
      Paint()..color = AppColors.primary.withValues(alpha: 0.12 + w * 0.04),
    );

    // Scattered neighbouring mini-pins that gently bob, staggered.
    const minis = [
      [-58.0, -34.0, 0.0],
      [60.0, -18.0, 0.33],
      [30.0, 58.0, 0.66],
    ];
    for (final m in minis) {
      final phase = math.sin((t + m[2]) * 2 * math.pi);
      _miniPin(
        canvas,
        Offset(c.dx + m[0], c.dy + m[1] + phase * 2.5),
        AppColors.primary.withValues(alpha: 0.55),
      );
    }
  }

  void _miniPin(Canvas canvas, Offset p, Color color) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(p.dx, p.dy - 2), 4.5, paint);
    canvas.drawPath(
      Path()
        ..moveTo(p.dx - 3.2, p.dy)
        ..lineTo(p.dx + 3.2, p.dy)
        ..lineTo(p.dx, p.dy + 7)
        ..close(),
      paint,
    );
    canvas.drawCircle(Offset(p.dx, p.dy - 2), 1.6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_WilayaPainter old) => old.t != t;
}

class _BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, 108, Paint()..color = AppColors.primaryLight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
