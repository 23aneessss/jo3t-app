import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class FoodPreferencesScreen extends StatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  State<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends State<FoodPreferencesScreen> {
  final _selected = <String>{};

  static const _prefs = [
    (icon: Icons.outdoor_grill_outlined, label: 'Grills & BBQ'),
    (icon: Icons.ramen_dining_outlined, label: 'Traditional Algerian'),
    (icon: Icons.local_cafe_outlined, label: 'Coffee & Cafés'),
    (icon: Icons.cake_outlined, label: 'Patisserie & Sweets'),
    (icon: Icons.lunch_dining_outlined, label: 'Sandwiches & Fast food'),
    (icon: Icons.local_drink_outlined, label: 'Juices & Smoothies'),
    (icon: Icons.local_pizza_outlined, label: 'Pizza & Italian'),
    (icon: Icons.eco_outlined, label: 'Salads & Healthy'),
    (icon: Icons.rice_bowl_outlined, label: 'Asian cuisine'),
    (icon: Icons.set_meal_outlined, label: 'Seafood'),
    (icon: Icons.bakery_dining_outlined, label: 'Bakeries'),
    (icon: Icons.fastfood_outlined, label: 'Street food'),
  ];

  bool get _canContinue => _selected.length >= 3;

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
                    'What do you love?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                      .animate()
                      .fadeIn(duration: AppAnimations.normal)
                      .slideY(begin: -0.1, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),

                  const SizedBox(height: AppSizes.s8),

                  Text(
                    'Pick at least 3. This shapes your discovery feed.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                      .animate(delay: const Duration(milliseconds: 80))
                      .fadeIn(duration: AppAnimations.normal),

                  const SizedBox(height: AppSizes.s8),

                  // Progress indicator
                  AnimatedContainer(
                    duration: AppAnimations.normal,
                    curve: AppAnimations.stateChange,
                    child: LinearProgressIndicator(
                      value: (_selected.length / 3).clamp(0.0, 1.0),
                      backgroundColor: AppColors.neutral100,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  )
                      .animate(delay: const Duration(milliseconds: 120))
                      .fadeIn(duration: AppAnimations.normal),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s20),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSizes.s8,
                  mainAxisSpacing: AppSizes.s8,
                  childAspectRatio: 1.0,
                ),
                itemCount: _prefs.length,
                itemBuilder: (context, i) {
                  final pref = _prefs[i];
                  final active = _selected.contains(pref.label);
                  return _PrefCard(
                    icon: pref.icon,
                    label: pref.label,
                    selected: active,
                    onTap: () => setState(() {
                      if (active) {
                        _selected.remove(pref.label);
                      } else {
                        _selected.add(pref.label);
                      }
                    }),
                    animationDelay: i,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s12,
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s32),
              child: Column(
                children: [
                  if (_selected.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_canContinue) ...[
                          const Icon(Icons.check_circle,
                              size: AppSizes.iconChip, color: AppColors.success),
                          const SizedBox(width: AppSizes.s6),
                        ],
                        Text(
                          _canContinue
                              ? '${_selected.length} selected'
                              : '${_selected.length} selected — pick ${3 - _selected.length} more',
                          style: TextStyle(
                            fontSize: 13,
                            color: _canContinue
                                ? AppColors.success
                                : AppColors.neutral500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: AppAnimations.fast),
                  const SizedBox(height: AppSizes.s12),
                  PrimaryButton(
                    label: 'Start exploring',
                    onTap: _canContinue ? () => context.go('/follow-suggestions') : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrefCard extends StatelessWidget {
  const _PrefCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.animationDelay,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.stateChange,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.neutral50,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.15 : 1.0,
              duration: AppAnimations.fast,
              curve: AppAnimations.overshoot,
              child: Icon(
                icon,
                size: 28,
                color: selected ? AppColors.primary : AppColors.neutral500,
              ),
            ),
            const SizedBox(height: AppSizes.s8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.neutral700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: (animationDelay * 40).clamp(0, 300)))
        .fadeIn(duration: AppAnimations.normal)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}
