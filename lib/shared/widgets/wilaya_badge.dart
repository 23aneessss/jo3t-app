import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class WilayaBadge extends StatelessWidget {
  const WilayaBadge({super.key, required this.wilaya, this.small = false});

  final String wilaya;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSizes.s8 : AppSizes.s12,
        vertical: small ? 3 : AppSizes.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: AppColors.neutral200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: small ? 10 : 12,
            color: AppColors.neutral500,
          ),
          const SizedBox(width: 3),
          Text(
            wilaya,
            style: TextStyle(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
