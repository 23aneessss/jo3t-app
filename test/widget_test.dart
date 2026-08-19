import 'package:flutter_test/flutter_test.dart';
import 'package:jo3t/core/constants/app_colors.dart';

void main() {
  group('AppColors.scoreColor', () {
    test('maps each JO3T Score band to its colour', () {
      expect(AppColors.scoreColor(1), AppColors.scoreLow);
      expect(AppColors.scoreColor(5), AppColors.scoreMid);
      expect(AppColors.scoreColor(7), AppColors.scoreHigh);
      expect(AppColors.scoreColor(9.1), AppColors.scoreTop);
    });

    test('band boundaries are inclusive of their upper bound', () {
      expect(AppColors.scoreColor(4), AppColors.scoreLow);
      expect(AppColors.scoreColor(4.1), AppColors.scoreMid);
      expect(AppColors.scoreColor(6), AppColors.scoreMid);
      expect(AppColors.scoreColor(6.1), AppColors.scoreHigh);
      expect(AppColors.scoreColor(8), AppColors.scoreHigh);
      expect(AppColors.scoreColor(8.1), AppColors.scoreTop);
    });

    test('handles the ends of the 1-10 range', () {
      expect(AppColors.scoreColor(0), AppColors.scoreLow);
      expect(AppColors.scoreColor(10), AppColors.scoreTop);
    });
  });
}
