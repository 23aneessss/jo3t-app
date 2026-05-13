import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(top: AppSizes.s12, bottom: AppSizes.s8),
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
      ),
    );
  }
}

// Helper to show a JO3T-styled bottom sheet
Future<T?> showJo3tBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusXl),
      ),
    ),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BottomSheetHandle(),
        child,
      ],
    ),
  );
}
