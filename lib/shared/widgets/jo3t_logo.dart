import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// JO3T brand assets — a single source of truth for the logo so it's identical
/// everywhere (splash, onboarding, auth).
///
/// - [Jo3tMark]      the symbol: a location pin with fork & knife cut out.
/// - [Jo3tWordmark]  the Arabic logotype "جعت" set in El Messiri.
/// - [Jo3tLogo]      the full vertical lockup (mark + wordmark + JO3T + tagline).

const String _kBrandFont = 'ElMessiri';

/// The location-pin-with-cutlery symbol, drawn as vectors so it stays crisp at
/// any size and matches `assets/branding/logo.svg`.
class Jo3tMark extends StatelessWidget {
  const Jo3tMark({
    super.key,
    this.size = 64,
    this.color = AppColors.primary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: CustomPaint(painter: _MarkPainter(color)),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Design space: 120 wide × 142 tall, scaled to fit.
    final s = size.width / 120.0;
    canvas.save();
    canvas.scale(s);

    // Teardrop pin — head circle (centre 60,58 r56), tapering to a point.
    final pin = Path()
      ..moveTo(60, 140)
      ..cubicTo(30, 100, 4, 86, 4, 58)
      ..arcToPoint(const Offset(116, 58),
          radius: const Radius.circular(58), clockwise: true)
      ..cubicTo(116, 86, 90, 100, 60, 140)
      ..close();

    // Cutlery cut out of the pin head (negative space).
    final cutlery = Path();
    // fork — three tines + handle
    for (final tx in [42.0, 50.0, 58.0]) {
      cutlery.addRRect(RRect.fromLTRBR(
          tx, 26, tx + 5, 47, const Radius.circular(2.5)));
    }
    cutlery.addRRect(
        RRect.fromLTRBR(46, 44, 61, 51, const Radius.circular(3)));
    cutlery.addRRect(
        RRect.fromLTRBR(50, 49, 56, 84, const Radius.circular(3)));
    // knife — blade + handle
    cutlery.addPath(
      Path()
        ..moveTo(74, 26)
        ..cubicTo(86, 26, 88, 50, 88, 62)
        ..cubicTo(88, 70, 80, 72, 74, 72)
        ..close(),
      Offset.zero,
    );
    cutlery.addRRect(
        RRect.fromLTRBR(72, 70, 78, 84, const Radius.circular(3)));

    final mark = Path.combine(PathOperation.difference, pin, cutlery);
    canvas.drawPath(mark, Paint()..color = color..isAntiAlias = true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.color != color;
}

/// The Arabic logotype "جعت" in El Messiri.
class Jo3tWordmark extends StatelessWidget {
  const Jo3tWordmark({
    super.key,
    this.fontSize = 72,
    this.color = AppColors.primary,
  });

  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'جعت',
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: _kBrandFont,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.0,
        // El Messiri is variable — pin the weight axis for consistent rendering.
        fontVariations: const [FontVariation('wght', 700)],
      ),
    );
  }
}

/// Full vertical lockup used on the splash screen.
class Jo3tLogo extends StatelessWidget {
  const Jo3tLogo({
    super.key,
    this.wordmarkColor = AppColors.primary,
    this.showMark = true,
    this.showTagline = true,
  });

  final Color wordmarkColor;
  final bool showMark;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMark) ...[
          Jo3tMark(size: 60, color: wordmarkColor),
          const SizedBox(height: 18),
        ],
        Jo3tWordmark(fontSize: 80, color: wordmarkColor),
        const SizedBox(height: 14),
        Text(
          'JO3T',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: wordmarkColor == Colors.white
                ? Colors.white
                : AppColors.neutral900,
            letterSpacing: 11,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 10),
          Text(
            "Algeria's food community",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: wordmarkColor == Colors.white
                  ? Colors.white.withValues(alpha: 0.85)
                  : AppColors.neutral500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
