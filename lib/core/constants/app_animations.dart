import 'package:flutter/material.dart';

abstract final class AppAnimations {
  // Durations
  static const Duration micro = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration badge = Duration(milliseconds: 400);

  // Curves
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve stateChange = Curves.easeInOutCubic;
  static const Curve bounce = Curves.elasticOut;
  static const Curve overshoot = Curves.easeOutBack;

  // Card press
  static const double cardPressScale = 0.98;
  static const double buttonPressScale = 0.97;
  static const double pinSelectScale = 1.3;

  // Entry offsets (feed cards slide up from)
  static const double cardEntryOffsetY = 12.0;

  // Stagger delay between list items
  static const Duration staggerDelay = Duration(milliseconds: 60);
}
