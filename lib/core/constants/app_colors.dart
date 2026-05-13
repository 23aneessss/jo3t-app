import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFE8520A);
  static const Color primaryLight = Color(0xFFFFF0E8);
  static const Color primaryDark = Color(0xFFB33E06);

  // Neutral
  static const Color neutral900 = Color(0xFF0F0F0F);
  static const Color neutral700 = Color(0xFF3A3A3A);
  static const Color neutral500 = Color(0xFF6B6B6B);
  static const Color neutral300 = Color(0xFFB0B0B0);
  static const Color neutral200 = Color(0xFFD8D8D8);
  static const Color neutral100 = Color(0xFFF2F2F2);
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral0 = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF1A9C5B);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Score colors
  static const Color scoreLow = Color(0xFFDC2626);
  static const Color scoreMid = Color(0xFFD97706);
  static const Color scoreHigh = Color(0xFFE8520A);
  static const Color scoreTop = Color(0xFF1A9C5B);

  // Dark mode surfaces
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkSecondaryText = Color(0xFF909090);
  static const Color darkPrimaryLight = Color(0xFF2A1A12);

  static Color scoreColor(double score) {
    if (score <= 4) return scoreLow;
    if (score <= 6) return scoreMid;
    if (score <= 8) return scoreHigh;
    return scoreTop;
  }
}
