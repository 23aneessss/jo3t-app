import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/jo3t_logo.dart';

/// Hand-composed onboarding illustrations — no emojis, no stock art.
/// Each is built from the brand palette and the JO3T mark so the three
/// screens feel like one designed set.

const double _kArt = 232;

/// Page 1 — Discover real places.
/// The JO3T pin at the centre of a radar of nearby places.
class DiscoverArt extends StatelessWidget {
  const DiscoverArt({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(_kArt, _kArt), painter: _DiscoverPainter()),
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
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);

    // Soft brand backdrop
    canvas.drawCircle(c, 108, Paint()..color = AppColors.primaryLight);

    // Radar rings
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = AppColors.primary.withValues(alpha: 0.18);
    canvas.drawCircle(c, 64, ring);
    canvas.drawCircle(c, 96, ring);

    // Nearby place dots sitting on the rings
    final dot = Paint()..color = AppColors.primary;
    final halo = Paint()..color = AppColors.primary.withValues(alpha: 0.16);
    for (final p in [
      Offset(c.dx + 64, c.dy - 30),
      Offset(c.dx - 72, c.dy + 18),
      Offset(c.dx + 34, c.dy + 78),
      Offset(c.dx - 30, c.dy - 80),
    ]) {
      canvas.drawCircle(p, 11, halo);
      canvas.drawCircle(p, 5, dot);
      canvas.drawCircle(p, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Page 2 — Honest community reviews.
/// Two overlapping review cards with a star row and a score badge.
class ReviewsArt extends StatelessWidget {
  const ReviewsArt({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(_kArt, _kArt), painter: _BackdropPainter()),
          // Back card
          Transform.translate(
            offset: const Offset(28, -36),
            child: Transform.rotate(
              angle: 0.10,
              child: _reviewCard(width: 150, faded: true),
            ),
          ),
          // Front card
          Transform.translate(
            offset: const Offset(-14, 26),
            child: Transform.rotate(
              angle: -0.05,
              child: _reviewCard(width: 168, faded: false),
            ),
          ),
        ],
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

/// Page 3 — Your wilaya, your feed.
/// A pin anchored on a stylised map region with local "ping" rings.
class WilayaArt extends StatelessWidget {
  const WilayaArt({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kArt,
      height: _kArt,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(_kArt, _kArt), painter: _WilayaPainter()),
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Jo3tMark(size: 52),
          ),
        ],
      ),
    );
  }
}

class _WilayaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, 108, Paint()..color = AppColors.primaryLight);

    // Stylised map region (soft blob)
    final region = Path()
      ..moveTo(c.dx - 70, c.dy - 28)
      ..cubicTo(c.dx - 40, c.dy - 74, c.dx + 36, c.dy - 70, c.dx + 64, c.dy - 30)
      ..cubicTo(c.dx + 88, c.dy + 2, c.dx + 52, c.dy + 64, c.dx + 8, c.dy + 70)
      ..cubicTo(c.dx - 44, c.dy + 78, c.dx - 92, c.dy + 22, c.dx - 70, c.dy - 28)
      ..close();
    canvas.drawPath(
        region, Paint()..color = AppColors.primary.withValues(alpha: 0.10));
    canvas.drawPath(
      region,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = AppColors.primary.withValues(alpha: 0.30),
    );

    // Local ping rings under the pin
    final ping = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = AppColors.primary.withValues(alpha: 0.25);
    canvas.drawCircle(Offset(c.dx, c.dy + 6), 30, ping);
    canvas.drawCircle(Offset(c.dx, c.dy + 6), 50, ping..color = AppColors.primary.withValues(alpha: 0.14));

    // Neighbouring places
    final dot = Paint()..color = AppColors.primary.withValues(alpha: 0.55);
    for (final p in [
      Offset(c.dx - 56, c.dy - 36),
      Offset(c.dx + 58, c.dy - 20),
      Offset(c.dx + 30, c.dy + 56),
    ]) {
      canvas.drawCircle(p, 4, dot);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
