import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  Future<void> _startPhoneAuth() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _PhoneEntrySheet(),
    );
    if (result != null && mounted) {
      context.push('/verify-phone', extra: result);
    }
  }

  void _googleComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-In is coming soon — use phone for now.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.s48),

              // Header
              Text(
                'جعت',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1,
                ),
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s16),

              Text(
                'Join Algeria\'s\nfood community.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: AppColors.neutral900,
                    ),
              )
                  .animate(delay: const Duration(milliseconds: 80))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s8),

              Text(
                'Discover real places, read honest reviews,\nand share your favorites.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
                  .animate(delay: const Duration(milliseconds: 140))
                  .fadeIn(duration: AppAnimations.normal),

              const Spacer(),

              // Auth options
              _SocialButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                iconColor: const Color(0xFF4285F4),
                onTap: _googleComingSoon,
              )
                  .animate(delay: const Duration(milliseconds: 200))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s12),

              _SocialButton(
                label: 'Continue with phone',
                icon: Icons.phone_outlined,
                iconColor: AppColors.neutral700,
                onTap: _startPhoneAuth,
              )
                  .animate(delay: const Duration(milliseconds: 260))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  ),

              const SizedBox(height: AppSizes.s16),

              // Guest mode
              Center(
                child: TextButton(
                  onPressed: () => context.go('/feed'),
                  child: Text(
                    'Browse as guest',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  .animate(delay: const Duration(milliseconds: 320))
                  .fadeIn(duration: AppAnimations.normal),

              const SizedBox(height: AppSizes.s24),

              // Legal
              Center(
                child: Text(
                  'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.neutral300,
                    height: 1.6,
                  ),
                ),
              )
                  .animate(delay: const Duration(milliseconds: 360))
                  .fadeIn(duration: AppAnimations.normal),

              const SizedBox(height: AppSizes.s16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet that collects a phone number and requests an OTP.
/// Pops with `{phone, verificationId}` on success.
class _PhoneEntrySheet extends ConsumerStatefulWidget {
  const _PhoneEntrySheet();

  @override
  ConsumerState<_PhoneEntrySheet> createState() => _PhoneEntrySheetState();
}

class _PhoneEntrySheetState extends ConsumerState<_PhoneEntrySheet> {
  final _controller = TextEditingController(text: '+213');
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final phone = _controller.text.replaceAll(' ', '').trim();
    if (phone.length < 8) {
      setState(() => _error = 'Enter a valid phone number');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    final id = await ref.read(authNotifierProvider.notifier).sendOtp(phone);
    if (!mounted) return;
    if (id == null) {
      setState(() {
        _sending = false;
        _error = 'Could not send the code. Check the number and try again.';
      });
      return;
    }
    Navigator.pop(context, {'phone': phone, 'verificationId': id});
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s24),
          const Text(
            'Enter your phone number',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          const Text(
            'We\'ll send you a 6-digit verification code.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            ],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral900,
            ),
            decoration: InputDecoration(
              hintText: '+213 555 000 000',
              filled: true,
              fillColor: AppColors.neutral50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              errorText: _error,
            ),
            onSubmitted: (_) => _send(),
          ),
          const SizedBox(height: AppSizes.s20),
          GestureDetector(
            onTap: _sending ? null : _send,
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              height: AppSizes.buttonHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Center(
                child: _sending
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Send code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? AppAnimations.cardPressScale : 1.0,
        duration: AppAnimations.micro,
        curve: AppAnimations.stateChange,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            color: _pressed ? AppColors.neutral100 : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.neutral200, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 24),
              const SizedBox(width: AppSizes.s12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
