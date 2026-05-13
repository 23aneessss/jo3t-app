import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _focused ? AppColors.primary : AppColors.neutral700,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: _focused ? AppColors.primary : AppColors.neutral200,
              width: _focused ? 1.5 : 1,
            ),
            color: isDark ? const Color(0xFF1A1A1A) : AppColors.neutral50,
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            autofocus: widget.autofocus,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFFF0F0F0) : AppColors.neutral900,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: AppColors.neutral300,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSizes.s12, right: AppSizes.s8),
                      child: Icon(
                        widget.prefixIcon,
                        size: AppSizes.iconInline,
                        color: _focused ? AppColors.primary : AppColors.neutral300,
                      ),
                    )
                  : null,
              prefixIconConstraints: widget.prefixIcon != null
                  ? const BoxConstraints(minWidth: 0, minHeight: 0)
                  : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s16,
                vertical: AppSizes.s16,
              ),
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}
