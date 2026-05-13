import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  int _step = 0;
  bool _submitting = false;

  // Step 1
  final _nameCtrl = TextEditingController();
  PlaceCategory? _category;

  // Step 2
  String? _wilaya;
  final _neighborhoodCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // Step 3 — photo (UI only for now)

  static const _steps = ['Basic info', 'Location', 'Photos'];

  bool get _step1Valid =>
      _nameCtrl.text.trim().length >= 2 && _category != null;

  bool get _step2Valid =>
      _wilaya != null && _neighborhoodCtrl.text.trim().isNotEmpty;

  bool get _currentStepValid => switch (_step) {
        0 => _step1Valid,
        1 => _step2Valid,
        _ => true,
      };

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Place submitted for review — thanks!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: _step == 0
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _back,
              ),
        title: const Text(
          'Add a place',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _StepProgressBar(currentStep: _step, totalSteps: _steps.length),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          _StepIndicator(steps: _steps, current: _step),

          // Step content
          Expanded(
            child: AnimatedSwitcher(
              duration: AppAnimations.medium,
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: AppAnimations.enter,
                ));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: _stepContent(),
              ),
            ),
          ),

          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding,
                AppSizes.s12,
                AppSizes.screenHorizontalPadding,
                AppSizes.s32),
            child: PrimaryButton(
              label: _step < 2 ? 'Continue' : 'Submit for review',
              onTap: _currentStepValid ? _next : null,
              loading: _submitting,
              icon: _step == 2 ? Icons.send_outlined : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepContent() => switch (_step) {
        0 => _Step1(
            nameCtrl: _nameCtrl,
            selected: _category,
            onNameChanged: (_) => setState(() {}),
            onCategorySelect: (c) => setState(() => _category = c),
          ),
        1 => _Step2(
            selectedWilaya: _wilaya,
            neighborhoodCtrl: _neighborhoodCtrl,
            addressCtrl: _addressCtrl,
            onWilayaSelect: (w) => setState(() => _wilaya = w),
            onChanged: () => setState(() {}),
          ),
        _ => _Step3(),
      };
}

// ---- Step Progress Bar ----

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar(
      {required this.currentStep, required this.totalSteps});
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppAnimations.medium,
      height: 3,
      child: LinearProgressIndicator(
        value: (currentStep + 1) / totalSteps,
        backgroundColor: AppColors.neutral100,
        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.steps, required this.current});
  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding,
          vertical: AppSizes.s16),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final active = e.key == current;
          final done = e.key < current;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? AppColors.success
                        : active
                            ? AppColors.primary
                            : AppColors.neutral100,
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : Text(
                            '${e.key + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: active
                                  ? Colors.white
                                  : AppColors.neutral300,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: AppAnimations.fast,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active
                          ? AppColors.primary
                          : done
                              ? AppColors.success
                              : AppColors.neutral300,
                    ),
                    child: Text(e.value),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---- Step 1: Basic Info ----

class _Step1 extends StatelessWidget {
  const _Step1({
    required this.nameCtrl,
    required this.selected,
    required this.onNameChanged,
    required this.onCategorySelect,
  });

  final TextEditingController nameCtrl;
  final PlaceCategory? selected;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<PlaceCategory> onCategorySelect;

  static final _categories = [
    (cat: PlaceCategory.restaurant, icon: Icons.restaurant, emoji: '🍽️'),
    (cat: PlaceCategory.cafe, icon: Icons.coffee, emoji: '☕'),
    (cat: PlaceCategory.patisserie, icon: Icons.cake, emoji: '🍰'),
    (cat: PlaceCategory.sandwich, icon: Icons.lunch_dining, emoji: '🥙'),
    (cat: PlaceCategory.streetFood, icon: Icons.storefront, emoji: '🌮'),
    (cat: PlaceCategory.juiceBar, icon: Icons.local_drink, emoji: '🥤'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s8),

          AppTextField(
            label: 'Place name',
            hint: 'e.g. Chez Fatima, Café Atlas…',
            controller: nameCtrl,
            onChanged: onNameChanged,
            autofocus: true,
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal)
              .slideY(begin: 0.1, end: 0, duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s24),

          const Text(
            'Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          )
              .animate(delay: const Duration(milliseconds: 60))
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: AppSizes.s8,
            mainAxisSpacing: AppSizes.s8,
            childAspectRatio: 1.15,
            children: _categories.asMap().entries.map((e) {
              final item = e.value;
              final active = selected == item.cat;
              return GestureDetector(
                onTap: () => onCategorySelect(item.cat),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.stateChange,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryLight : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: active ? AppColors.primary : AppColors.neutral200,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: active ? 1.2 : 1.0,
                        duration: AppAnimations.fast,
                        curve: AppAnimations.overshoot,
                        child: Text(item.emoji,
                            style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.cat.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: active
                              ? AppColors.primary
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: 80 + e.key * 40))
                  .fadeIn(duration: AppAnimations.normal)
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                    curve: AppAnimations.enter,
                    duration: AppAnimations.normal,
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ---- Step 2: Location ----

class _Step2 extends StatelessWidget {
  const _Step2({
    required this.selectedWilaya,
    required this.neighborhoodCtrl,
    required this.addressCtrl,
    required this.onWilayaSelect,
    required this.onChanged,
  });

  final String? selectedWilaya;
  final TextEditingController neighborhoodCtrl;
  final TextEditingController addressCtrl;
  final ValueChanged<String> onWilayaSelect;
  final VoidCallback onChanged;

  static const _topWilayas = [
    '16 · Alger', '09 · Blida', '31 · Oran', '25 · Constantine',
    '15 · Tizi Ouzou', '35 · Boumerdès', '19 · Sétif', '23 · Annaba',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s8),

          const Text('Wilaya',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral700)),
          const SizedBox(height: AppSizes.s12),

          Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: _topWilayas.asMap().entries.map((e) {
              final w = e.value;
              final active = selectedWilaya == w;
              return GestureDetector(
                onTap: () => onWilayaSelect(w),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s12, vertical: AppSizes.s8),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryLight : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: active ? AppColors.primary : AppColors.neutral200,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    w.split('·').last.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? AppColors.primary : AppColors.neutral700,
                    ),
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: e.key * 35))
                  .fadeIn(duration: AppAnimations.normal)
                  .scale(
                    begin: const Offset(0.88, 0.88),
                    end: const Offset(1, 1),
                    curve: AppAnimations.enter,
                    duration: AppAnimations.fast,
                  );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.s24),

          AppTextField(
            label: 'Neighborhood',
            hint: 'e.g. Hydra, Bab El Oued, Centre-ville…',
            controller: neighborhoodCtrl,
            onChanged: (_) => onChanged(),
            prefixIcon: Icons.location_city_outlined,
          )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn(duration: AppAnimations.normal)
              .slideY(begin: 0.1, end: 0, duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s16),

          AppTextField(
            label: 'Address',
            hint: 'Street address (optional)',
            controller: addressCtrl,
            onChanged: (_) => onChanged(),
            prefixIcon: Icons.signpost_outlined,
          )
              .animate(delay: const Duration(milliseconds: 260))
              .fadeIn(duration: AppAnimations.normal)
              .slideY(begin: 0.1, end: 0, duration: AppAnimations.normal),
        ],
      ),
    );
  }
}

// ---- Step 3: Photos ----

class _Step3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s8),

          const Text(
            'Add a cover photo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s12),

          // Upload zone
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: AppColors.neutral200,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.primary, size: 26),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  const Text(
                    'Tap to add a photo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'JPEG, PNG · max 5MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral300,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal)
                .scale(
                  begin: const Offset(0.92, 0.92),
                  end: const Offset(1, 1),
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),
          ),

          const SizedBox(height: AppSizes.s24),

          // Submission info
          Container(
            padding: const EdgeInsets.all(AppSizes.s16),
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.neutral100),
            ),
            child: const Column(
              children: [
                _InfoRow(
                  icon: Icons.timer_outlined,
                  text: 'Your submission will be reviewed within 24 hours.',
                ),
                SizedBox(height: AppSizes.s12),
                _InfoRow(
                  icon: Icons.verified_user_outlined,
                  text: 'Our moderators ensure quality for the whole community.',
                ),
                SizedBox(height: AppSizes.s12),
                _InfoRow(
                  icon: Icons.notifications_outlined,
                  text: "You'll be notified when your place goes live.",
                ),
              ],
            ),
          )
              .animate(delay: const Duration(milliseconds: 150))
              .fadeIn(duration: AppAnimations.normal)
              .slideY(begin: 0.1, end: 0, duration: AppAnimations.normal),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.neutral500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
