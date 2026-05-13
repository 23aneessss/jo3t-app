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

  static const _steps = ['Basic Info', 'Location', 'Photos'];

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
              Text('Place submitted — we\'ll review it soon!'),
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
      body: Column(
        children: [
          _AddPlaceHeader(
            step: _step,
            steps: _steps,
            onClose: () => context.pop(),
            onBack: _back,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppAnimations.medium,
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  begin: const Offset(0.06, 0),
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
          _AddPlaceCTA(
            step: _step,
            enabled: _currentStepValid,
            loading: _submitting,
            onTap: _next,
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
        _ => const _Step3(),
      };
}

// ---- Header with progress ----

class _AddPlaceHeader extends StatelessWidget {
  const _AddPlaceHeader({
    required this.step,
    required this.steps,
    required this.onClose,
    required this.onBack,
  });
  final int step;
  final List<String> steps;
  final VoidCallback onClose;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Navigation row
          Padding(
            padding: const EdgeInsets.fromLTRB(4, AppSizes.s8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(step == 0 ? Icons.close : Icons.arrow_back_ios_new,
                      size: 20),
                  onPressed: step == 0 ? onClose : onBack,
                  color: AppColors.neutral700,
                ),
                const Spacer(),
                Text(
                  'Step ${step + 1} of ${steps.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.s8),

          // Step dots + lines
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: Row(
              children: steps.asMap().entries.map((e) {
                final active = e.key == step;
                final done = e.key < step;
                return Expanded(
                  child: Row(
                    children: [
                      // Circle
                      AnimatedContainer(
                        duration: AppAnimations.medium,
                        curve: AppAnimations.stateChange,
                        width: active ? 36 : 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.success
                              : active
                                  ? AppColors.primary
                                  : AppColors.neutral100,
                          borderRadius: BorderRadius.circular(
                              active ? AppSizes.radiusMd : AppSizes.radiusFull),
                        ),
                        child: Center(
                          child: done
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 14)
                              : active
                                  ? Text(
                                      '${e.key + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      '${e.key + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.neutral300,
                                      ),
                                    ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.s8),
                      // Label
                      AnimatedDefaultTextStyle(
                        duration: AppAnimations.fast,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w400,
                          color: active
                              ? AppColors.primary
                              : done
                                  ? AppColors.success
                                  : AppColors.neutral300,
                        ),
                        child: Text(e.value),
                      ),
                      // Connector line (except last)
                      if (e.key < steps.length - 1)
                        Expanded(
                          child: AnimatedContainer(
                            duration: AppAnimations.medium,
                            height: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: AppSizes.s6),
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.success
                                  : AppColors.neutral100,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusFull),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSizes.s4),

          // Progress bar
          AnimatedContainer(
            duration: AppAnimations.medium,
            height: 3,
            child: LinearProgressIndicator(
              value: (step + 1) / steps.length,
              backgroundColor: AppColors.neutral100,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// ---- CTA Button area ----

class _AddPlaceCTA extends StatelessWidget {
  const _AddPlaceCTA({
    required this.step,
    required this.enabled,
    required this.loading,
    required this.onTap,
  });
  final int step;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding,
          AppSizes.s12,
          AppSizes.screenHorizontalPadding,
          AppSizes.s32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.neutral100)),
      ),
      child: PrimaryButton(
        label: step < 2 ? 'Continue' : 'Submit for review',
        onTap: enabled ? onTap : null,
        loading: loading,
        icon: step == 2 ? Icons.send_outlined : null,
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
    (cat: PlaceCategory.restaurant, emoji: '🍽️', label: 'Restaurant'),
    (cat: PlaceCategory.cafe, emoji: '☕', label: 'Café'),
    (cat: PlaceCategory.patisserie, emoji: '🍰', label: 'Patisserie'),
    (cat: PlaceCategory.sandwich, emoji: '🥙', label: 'Sandwich'),
    (cat: PlaceCategory.streetFood, emoji: '🌮', label: 'Street Food'),
    (cat: PlaceCategory.juiceBar, emoji: '🥤', label: 'Juice Bar'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s20),

          // Step headline
          _StepHeadline(
            icon: Icons.storefront_outlined,
            title: 'Tell us about the place',
            subtitle: 'Give us a name and pick the right category.',
          ),

          const SizedBox(height: AppSizes.s24),

          AppTextField(
            label: 'Place name',
            hint: 'e.g. Chez Fatima, Café Atlas…',
            controller: nameCtrl,
            onChanged: onNameChanged,
            autofocus: true,
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter),

          const SizedBox(height: AppSizes.s24),

          const Text(
            'Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          )
              .animate(delay: 60.ms)
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.s10,
            mainAxisSpacing: AppSizes.s10,
            childAspectRatio: 2.2,
            children: _categories.asMap().entries.map((e) {
              final item = e.value;
              final active = selected == item.cat;
              return GestureDetector(
                onTap: () => onCategorySelect(item.cat),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.stateChange,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryLight
                        : AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.neutral200,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: AppSizes.s14),
                      AnimatedScale(
                        scale: active ? 1.15 : 1.0,
                        duration: AppAnimations.fast,
                        curve: AppAnimations.overshoot,
                        child: Text(item.emoji,
                            style: const TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: AppSizes.s10),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: active
                              ? AppColors.primary
                              : AppColors.neutral700,
                        ),
                      ),
                      const Spacer(),
                      if (active) ...[
                        const Icon(Icons.check_circle,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: AppSizes.s12),
                      ],
                    ],
                  ),
                ),
              )
                  .animate(
                      delay: Duration(milliseconds: 80 + e.key * 35))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideX(
                    begin: 0.05,
                    end: 0,
                    curve: AppAnimations.enter,
                    duration: AppAnimations.normal,
                  );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.s24),
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
    '16 · Alger',
    '09 · Blida',
    '31 · Oran',
    '25 · Constantine',
    '15 · Tizi Ouzou',
    '35 · Boumerdès',
    '19 · Sétif',
    '23 · Annaba',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s20),

          _StepHeadline(
            icon: Icons.location_on_outlined,
            title: 'Where is it located?',
            subtitle: 'Pick the wilaya and add the neighborhood.',
          ),

          const SizedBox(height: AppSizes.s24),

          // Location illustration card
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F9FF), Color(0xFFE8F4FD)],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: const Color(0xFFD0E8F7)),
            ),
            child: Stack(
              children: [
                // Mock roads
                Positioned.fill(
                  child: CustomPaint(painter: _MiniMapPainter()),
                ),
                // Pin overlay
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on,
                          size: 28, color: AppColors.primary),
                      SizedBox(height: 4),
                      Text(
                        'Your place will appear here',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal)
              .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  curve: AppAnimations.enter,
                  duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s24),

          Row(
            children: const [
              Icon(Icons.map_outlined, size: 14, color: AppColors.neutral500),
              SizedBox(width: AppSizes.s8),
              Text(
                'Select wilaya',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral700,
                ),
              ),
            ],
          )
              .animate(delay: 60.ms)
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s12),

          Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: _topWilayas.asMap().entries.map((e) {
              final w = e.value;
              final label = w.split('·').last.trim();
              final active = selectedWilaya == w;
              return GestureDetector(
                onTap: () => onWilayaSelect(w),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s14, vertical: AppSizes.s8),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryLight
                        : AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.neutral200,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (active) ...[
                        const Icon(Icons.check_circle,
                            size: 13, color: AppColors.primary),
                        const SizedBox(width: AppSizes.s4),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w400,
                          color: active
                              ? AppColors.primary
                              : AppColors.neutral700,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(
                      delay: Duration(milliseconds: e.key * 30))
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
              .animate(delay: 200.ms)
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter),

          const SizedBox(height: AppSizes.s16),

          AppTextField(
            label: 'Address (optional)',
            hint: 'Street name, building number…',
            controller: addressCtrl,
            onChanged: (_) => onChanged(),
            prefixIcon: Icons.signpost_outlined,
          )
              .animate(delay: 250.ms)
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter),

          const SizedBox(height: AppSizes.s24),
        ],
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Horizontal roads
    canvas.drawLine(Offset(0, size.height * 0.35),
        Offset(size.width, size.height * 0.35), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.65),
        Offset(size.width, size.height * 0.65), roadPaint);
    // Vertical roads
    canvas.drawLine(Offset(size.width * 0.25, 0),
        Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.6, 0),
        Offset(size.width * 0.6, size.height), roadPaint);

    // Blocks
    final blockPaint = Paint()
      ..color = const Color(0xFFD0E8F7)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.3, 8, size.width * 0.28, size.height * 0.3),
        const Radius.circular(4),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.64, size.height * 0.7,
            size.width * 0.32, size.height * 0.22),
        const Radius.circular(4),
      ),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---- Step 3: Photos ----

class _Step3 extends StatelessWidget {
  const _Step3();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s20),

          const _StepHeadline(
            icon: Icons.photo_camera_outlined,
            title: 'Show us what it looks like',
            subtitle: 'A great photo helps others discover the place.',
          ),

          const SizedBox(height: AppSizes.s24),

          // Upload zone (dashed border)
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: CustomPaint(
                painter: _DashedBorderPainter(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.primary, size: 26),
                    ),
                    const SizedBox(height: AppSizes.s12),
                    const Text(
                      'Tap to add a cover photo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'JPEG or PNG · max 5 MB',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral300,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal)
                .scale(
                  begin: const Offset(0.93, 0.93),
                  end: const Offset(1, 1),
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),
          ),

          const SizedBox(height: AppSizes.s16),

          // Extra photo slots row
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: i == 0 ? 0 : AppSizes.s8),
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                        color: AppColors.neutral200, width: 1.5),
                  ),
                  child: const Icon(Icons.add,
                      size: 22, color: AppColors.neutral300),
                ),
              );
            }),
          )
              .animate(delay: 80.ms)
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s24),

          // Review info cards
          Column(
            children: [
              _InfoCard(
                icon: Icons.timer_outlined,
                title: '24h review',
                subtitle: 'Your place will be reviewed within 24 hours.',
                delay: 0,
              ),
              const SizedBox(height: AppSizes.s10),
              _InfoCard(
                icon: Icons.verified_user_outlined,
                title: 'Moderated quality',
                subtitle:
                    'Our team ensures accurate info for everyone.',
                delay: 1,
              ),
              const SizedBox(height: AppSizes.s10),
              _InfoCard(
                icon: Icons.notifications_outlined,
                title: 'Get notified',
                subtitle: "You'll be notified when your place goes live.",
                delay: 2,
              ),
            ],
          )
              .animate(delay: 150.ms)
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter),

          const SizedBox(height: AppSizes.s24),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 5.0;
    const radius = AppSizes.radiusLg;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final remaining = metric.length - distance;
        final drawLength = remaining < dashWidth ? remaining : dashWidth;
        canvas.drawPath(metric.extractPath(distance, distance + drawLength),
            paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.delay,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Shared: Step Headline ----

class _StepHeadline extends StatelessWidget {
  const _StepHeadline({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: AppSizes.s14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.neutral500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal)
        .slideX(
            begin: -0.05,
            end: 0,
            duration: AppAnimations.normal,
            curve: AppAnimations.enter);
  }
}
