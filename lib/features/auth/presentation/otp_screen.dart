import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _otp = '';
  bool _verifying = false;
  bool _verified = false;
  int _resendSeconds = 45;
  Timer? _timer;

  late final AnimationController _successCtrl;
  late final Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );
    _successScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successCtrl, curve: AppAnimations.overshoot),
    );
    _startResendTimer();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          t.cancel();
        }
      });
    });
  }

  void _onChanged(String v) {
    final digits = v.replaceAll(RegExp(r'\D'), '');
    final clamped = digits.length > 6 ? digits.substring(0, 6) : digits;
    _controller.value = TextEditingValue(
      text: clamped,
      selection: TextSelection.collapsed(offset: clamped.length),
    );
    setState(() => _otp = clamped);
    if (clamped.length == 6) _verify();
  }

  Future<void> _verify() async {
    _focus.unfocus();
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _verifying = false;
      _verified = true;
    });
    _successCtrl.forward();
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) context.go('/wilaya-select');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: AppColors.neutral700),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.s24),

              // Header
              Text(
                _verified ? 'Verified! 🎉' : 'Verify your number',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(begin: -0.1, end: 0, curve: AppAnimations.enter),

              const SizedBox(height: AppSizes.s8),

              Text(
                'Enter the 6-digit code sent to\n+213 ••• ••• ••42',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.neutral500,
                  height: 1.5,
                ),
              )
                  .animate(delay: 60.ms)
                  .fadeIn(duration: AppAnimations.normal),

              const SizedBox(height: AppSizes.s48),

              // OTP boxes
              AnimatedSwitcher(
                duration: AppAnimations.medium,
                child: _verified
                    ? _buildSuccessCheck()
                    : _buildOTPField(),
              ),

              const SizedBox(height: AppSizes.s32),

              // Verify button
              if (!_verified)
                _VerifyButton(
                  otp: _otp,
                  verifying: _verifying,
                  onTap: _otp.length == 6 && !_verifying ? _verify : null,
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: AppAnimations.normal)
                    .slideY(begin: 0.15, end: 0, curve: AppAnimations.enter),

              const SizedBox(height: AppSizes.s20),

              // Resend
              if (!_verified)
                Center(
                  child: _resendSeconds > 0
                      ? Text(
                          'Resend code in ${_resendSeconds}s',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.neutral300,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _startResendTimer();
                            _controller.clear();
                            setState(() => _otp = '');
                            _focus.requestFocus();
                          },
                          child: const Text(
                            'Resend code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                )
                    .animate(delay: 250.ms)
                    .fadeIn(duration: AppAnimations.normal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCheck() {
    return Center(
      key: const ValueKey('success'),
      child: ScaleTransition(
        scale: _successScale,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded,
              size: 52, color: AppColors.success),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return GestureDetector(
      key: const ValueKey('otp'),
      onTap: () => _focus.requestFocus(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hidden capture field
          Opacity(
            opacity: 0.001,
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                decoration: const InputDecoration(counterText: ''),
                onChanged: _onChanged,
                style: const TextStyle(fontSize: 1, color: Colors.transparent),
              ),
            ),
          ),
          // Visual boxes
          IgnorePointer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final filled = i < _otp.length;
                final active = i == _otp.length && !_verifying;
                return _OTPBox(
                  digit: filled ? _otp[i] : null,
                  active: active,
                  verifying: _verifying,
                  index: i,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _OTPBox extends StatelessWidget {
  const _OTPBox({
    required this.digit,
    required this.active,
    required this.verifying,
    required this.index,
  });
  final String? digit;
  final bool active;
  final bool verifying;
  final int index;

  @override
  Widget build(BuildContext context) {
    final filled = digit != null;
    return AnimatedContainer(
      duration: AppAnimations.fast,
      curve: AppAnimations.stateChange,
      width: 46,
      height: 58,
      decoration: BoxDecoration(
        color: verifying
            ? AppColors.primaryLight
            : filled
                ? AppColors.neutral50
                : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: verifying
              ? AppColors.primary.withValues(alpha: 0.4)
              : active
                  ? AppColors.primary
                  : filled
                      ? AppColors.neutral300
                      : AppColors.neutral200,
          width: active || verifying ? 2 : 1.5,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 12,
                  spreadRadius: 0,
                )
              ]
            : [],
      ),
      child: Center(
        child: filled
            ? Text(
                digit!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                ),
              )
            : active
                ? _CursorBlink()
                : null,
      ),
    )
        .animate(delay: Duration(milliseconds: index * 40))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(
          begin: 0.2,
          end: 0,
          curve: AppAnimations.overshoot,
          duration: AppAnimations.normal,
        );
  }
}

class _CursorBlink extends StatefulWidget {
  @override
  State<_CursorBlink> createState() => _CursorBlinkState();
}

class _CursorBlinkState extends State<_CursorBlink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 2,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _VerifyButton extends StatefulWidget {
  const _VerifyButton({
    required this.otp,
    required this.verifying,
    required this.onTap,
  });
  final String otp;
  final bool verifying;
  final VoidCallback? onTap;

  @override
  State<_VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<_VerifyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppAnimations.fast,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark])
                : null,
            color: enabled ? null : AppColors.neutral100,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: widget.verifying
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Verify code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: enabled ? Colors.white : AppColors.neutral300,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
