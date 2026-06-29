import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class WilayaSelectScreen extends StatefulWidget {
  const WilayaSelectScreen({super.key});

  @override
  State<WilayaSelectScreen> createState() => _WilayaSelectScreenState();
}

class _WilayaSelectScreenState extends State<WilayaSelectScreen> {
  String? _selected;
  String _search = '';

  static const _wilayas = [
    '01 · Adrar', '02 · Chlef', '03 · Laghouat', '04 · Oum el Bouaghi',
    '05 · Batna', '06 · Béjaïa', '07 · Biskra', '08 · Béchar',
    '09 · Blida', '10 · Bouira', '11 · Tamanrasset', '12 · Tébessa',
    '13 · Tlemcen', '14 · Tiaret', '15 · Tizi Ouzou', '16 · Alger',
    '17 · Djelfa', '18 · Jijel', '19 · Sétif', '20 · Saïda',
    '21 · Skikda', '22 · Sidi Bel Abbès', '23 · Annaba', '24 · Guelma',
    '25 · Constantine', '26 · Médéa', '27 · Mostaganem', '28 · M\'Sila',
    '29 · Mascara', '30 · Ouargla', '31 · Oran', '32 · El Bayadh',
    '33 · Illizi', '34 · Bordj Bou Arréridj', '35 · Boumerdès',
    '36 · El Tarf', '37 · Tindouf', '38 · Tissemsilt', '39 · El Oued',
    '40 · Khenchela', '41 · Souk Ahras', '42 · Tipaza', '43 · Mila',
    '44 · Aïn Defla', '45 · Naâma', '46 · Aïn Témouchent',
    '47 · Ghardaïa', '48 · Relizane',
  ];

  List<String> get _filtered => _search.isEmpty
      ? _wilayas
      : _wilayas
          .where((w) => w.toLowerCase().contains(_search.toLowerCase()))
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s32,
                  AppSizes.screenHorizontalPadding,
                  0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where are you based?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                      .animate()
                      .fadeIn(duration: AppAnimations.normal)
                      .slideY(
                        begin: -0.1,
                        end: 0,
                        duration: AppAnimations.normal,
                        curve: AppAnimations.enter,
                      ),

                  const SizedBox(height: AppSizes.s8),

                  Text(
                    'Your wilaya shapes your feed. You can change this later.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                      .animate(delay: const Duration(milliseconds: 80))
                      .fadeIn(duration: AppAnimations.normal),

                  const SizedBox(height: AppSizes.s20),

                  // Search
                  TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search wilaya…',
                      prefixIcon: const Icon(Icons.search,
                          size: AppSizes.iconInline, color: AppColors.neutral300),
                    ),
                  )
                      .animate(delay: const Duration(milliseconds: 120))
                      .fadeIn(duration: AppAnimations.normal),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s12),

            // Wilaya list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final wilaya = _filtered[i];
                  final selected = _selected == wilaya;
                  return _WilayaTile(
                    label: wilaya,
                    selected: selected,
                    onTap: () => setState(() => _selected = wilaya),
                    animationIndex: i,
                  );
                },
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
                label: 'Continue',
                onTap: _selected != null
                    ? () => context.go('/food-preferences')
                    : null,
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 200)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WilayaTile extends StatelessWidget {
  const _WilayaTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.animationIndex,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int animationIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.stateChange,
        margin: const EdgeInsets.symmetric(vertical: AppSizes.s4),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16, vertical: AppSizes.s14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral100,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.primary : AppColors.neutral900,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: selected
                  ? const Icon(Icons.check_circle,
                      key: ValueKey(true),
                      color: AppColors.primary,
                      size: AppSizes.iconInline)
                  : const SizedBox(
                      key: ValueKey(false), width: AppSizes.iconInline),
            ),
          ],
        ),
      ),
    )
        .animate(
          delay: Duration(
              milliseconds:
                  (animationIndex * 18).clamp(0, 180)),
        )
        .fadeIn(duration: AppAnimations.fast)
        .slideX(
          begin: 0.04,
          end: 0,
          duration: AppAnimations.fast,
          curve: AppAnimations.enter,
        );
  }
}

