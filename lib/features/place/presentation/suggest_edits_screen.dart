import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/primary_button.dart';

class SuggestEditsScreen extends StatefulWidget {
  const SuggestEditsScreen(
      {super.key, required this.placeId, required this.placeName});
  final String placeId;
  final String placeName;

  @override
  State<SuggestEditsScreen> createState() => _SuggestEditsScreenState();
}

class _SuggestEditsScreenState extends State<SuggestEditsScreen> {
  bool _submitting = false;

  PlaceModel get _place =>
      MockData.places.firstWhere((p) => p.id == widget.placeId,
          orElse: () => MockData.places.first);

  // Field controllers pre-filled with current data
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _noteCtrl;
  late PlaceCategory _category;
  late PriceRange _price;
  bool _isOpen = true;
  final Set<String> _changes = {};

  @override
  void initState() {
    super.initState();
    final p = _place;
    _nameCtrl = TextEditingController(text: p.name);
    _addressCtrl = TextEditingController(text: p.address);
    _phoneCtrl = TextEditingController();
    _noteCtrl = TextEditingController();
    _category = p.category;
    _price = p.priceRange;
    _isOpen = p.isOpen;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Suggestion submitted — thanks for helping!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        backgroundColor: AppColors.neutral0,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppColors.neutral900,
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggest edits',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            Text(widget.placeName,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.neutral500)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(AppSizes.s14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: AppSizes.s10),
                  Expanded(
                    child: Text(
                      'Your suggestion will be reviewed by our team within 48 hours.',
                      style: TextStyle(
                          color: AppColors.primary.withValues(alpha: 0.85),
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal),

            const SizedBox(height: AppSizes.s24),

            _EditSection(
              title: 'Basic info',
              animIndex: 1,
              child: Column(
                children: [
                  _LabeledField(
                    label: 'Place name',
                    controller: _nameCtrl,
                  ),
                  const SizedBox(height: AppSizes.s16),
                  _LabeledField(
                    label: 'Address',
                    controller: _addressCtrl,
                  ),
                  const SizedBox(height: AppSizes.s16),
                  _LabeledField(
                    label: 'Phone number (optional)',
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    hint: '+213 XXX XXX XXX',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _EditSection(
              title: 'Category & price',
              animIndex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral700)),
                  const SizedBox(height: AppSizes.s10),
                  Wrap(
                    spacing: AppSizes.s8,
                    runSpacing: AppSizes.s8,
                    children: PlaceCategory.values.map((cat) {
                      final selected = _category == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _category = cat),
                        child: AnimatedContainer(
                          duration: AppAnimations.fast,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s12, vertical: AppSizes.s6),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.neutral100,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: Text(cat.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? Colors.white
                                    : AppColors.neutral700,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  const Text('Price range',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral700)),
                  const SizedBox(height: AppSizes.s10),
                  Row(
                    children: PriceRange.values.map((p) {
                      final selected = _price == p;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSizes.s8),
                        child: GestureDetector(
                          onTap: () => setState(() => _price = p),
                          child: AnimatedContainer(
                            duration: AppAnimations.fast,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.s16, vertical: AppSizes.s8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.neutral100,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(p.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.neutral700,
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _EditSection(
              title: 'Status',
              animIndex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Currently open?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.neutral900)),
                        Text(
                          _isOpen ? 'Yes, open' : 'No, closed',
                          style: TextStyle(
                              fontSize: 12,
                              color: _isOpen
                                  ? AppColors.success
                                  : AppColors.neutral500),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOpen,
                    onChanged: (v) => setState(() => _isOpen = v),
                    activeTrackColor: AppColors.success,
                    activeThumbColor: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            _EditSection(
              title: 'Additional notes',
              animIndex: 4,
              child: TextField(
                controller: _noteCtrl,
                maxLines: 3,
                maxLength: 250,
                decoration: InputDecoration(
                  hintText:
                      'Anything else we should know? (permanently closed, moved location, etc.)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  counterStyle: const TextStyle(
                      fontSize: 11, color: AppColors.neutral300),
                  contentPadding: const EdgeInsets.all(AppSizes.s12),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s32),

            PrimaryButton(
              label: 'Submit suggestion',
              loading: _submitting,
              onTap: _submit,
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: AppAnimations.normal)
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppSizes.s48),
          ],
        ),
      ),
    );
  }
}

class _EditSection extends StatelessWidget {
  const _EditSection({
    required this.title,
    required this.child,
    required this.animIndex,
  });
  final String title;
  final Widget child;
  final int animIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              )),
          const SizedBox(height: AppSizes.s16),
          child,
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animIndex * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.05, end: 0);
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral700)),
        const SizedBox(height: AppSizes.s6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.neutral300),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              borderSide: const BorderSide(color: AppColors.neutral200),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s12, vertical: AppSizes.s12),
          ),
        ),
      ],
    );
  }
}
