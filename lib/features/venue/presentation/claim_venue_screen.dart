import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class ClaimVenueScreen extends StatefulWidget {
  const ClaimVenueScreen({super.key, required this.placeId, required this.placeName});
  final String placeId;
  final String placeName;

  @override
  State<ClaimVenueScreen> createState() => _ClaimVenueScreenState();
}

class _ClaimVenueScreenState extends State<ClaimVenueScreen> {
  int _step = 0;
  bool _submitting = false;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _verificationMethod;

  static const _steps = ['Verify ownership', 'Contact info', 'Review & submit'];

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppColors.neutral900,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Claim this place',
          style: TextStyle(
            color: AppColors.neutral900,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_step + 1) / _steps.length,
            backgroundColor: AppColors.neutral100,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 3,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: AnimatedSwitcher(
                duration: AppAnimations.normal,
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _buildStep(),
                ),
              ),
            ),
          ),

          // Bottom actions
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.s24, 0, AppSizes.s24, AppSizes.s16),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step--),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.neutral200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: AppSizes.s12),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: _step < _steps.length - 1 ? 'Continue' : 'Submit claim',
                      loading: _submitting,
                      onTap: _step < _steps.length - 1
                          ? () => setState(() => _step++)
                          : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _buildVerifyStep(),
      1 => _buildContactStep(),
      _ => _buildReviewStep(),
    };
  }

  Widget _buildVerifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.verified_outlined,
          title: 'How do you want to verify ownership?',
          subtitle: 'We need to confirm you are the owner or manager of ${widget.placeName}.',
        ),
        const SizedBox(height: AppSizes.s24),
        ...[
          (icon: Icons.receipt_long_outlined, method: 'documents', label: 'Business documents', desc: 'Upload trade register or tax certificate'),
          (icon: Icons.phone_outlined, method: 'phone', label: 'Phone call verification', desc: 'Receive a call on the venue\'s listed number'),
          (icon: Icons.email_outlined, method: 'email', label: 'Business email', desc: 'Verify via an email matching your venue\'s domain'),
        ].map((opt) {
          final selected = _verificationMethod == opt.method;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s12),
            child: GestureDetector(
              onTap: () => setState(() => _verificationMethod = opt.method),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryLight : AppColors.neutral50,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.neutral200,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(opt.icon,
                        color: selected ? AppColors.primary : AppColors.neutral500,
                        size: 22),
                    const SizedBox(width: AppSizes.s14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: selected ? AppColors.primary : AppColors.neutral900,
                              )),
                          Text(opt.desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.neutral500,
                              )),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    ).animate().fadeIn(duration: AppAnimations.normal).slideY(begin: 0.05, end: 0);
  }

  Widget _buildContactStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.contact_mail_outlined,
          title: 'Your contact info',
          subtitle: 'We\'ll reach out to complete the verification process.',
        ),
        const SizedBox(height: AppSizes.s24),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone number',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.s16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Business email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: AppAnimations.normal).slideY(begin: 0.05, end: 0);
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.task_alt_rounded,
          title: 'Review your claim',
          subtitle: 'Once submitted, our team will review within 48 hours.',
        ),
        const SizedBox(height: AppSizes.s24),
        Container(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            children: [
              _ReviewRow(label: 'Place', value: widget.placeName),
              const Divider(height: AppSizes.s24),
              _ReviewRow(
                  label: 'Verification',
                  value: _verificationMethod ?? 'Not selected'),
              const Divider(height: AppSizes.s24),
              _ReviewRow(label: 'Phone', value: _phoneController.text.isEmpty ? '—' : _phoneController.text),
              const Divider(height: AppSizes.s24),
              _ReviewRow(label: 'Email', value: _emailController.text.isEmpty ? '—' : _emailController.text),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s16),
        Container(
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 18),
              const SizedBox(width: AppSizes.s10),
              Expanded(
                child: Text(
                  'False claims are subject to account suspension.',
                  style: TextStyle(color: AppColors.warning, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: AppAnimations.normal).slideY(begin: 0.05, end: 0);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Claim submitted — we\'ll review within 48 hours'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: AppSizes.s16),
        Text(title,
            style: TextStyle(
              color: AppColors.neutral900,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
            )),
        const SizedBox(height: AppSizes.s8),
        Text(subtitle,
            style: TextStyle(color: AppColors.neutral500, fontSize: 14, height: 1.5)),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.neutral500, fontSize: 13)),
        Text(value,
            style: TextStyle(
                color: AppColors.neutral900,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
