import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';

class FollowSuggestionsScreen extends StatefulWidget {
  const FollowSuggestionsScreen({super.key});

  @override
  State<FollowSuggestionsScreen> createState() =>
      _FollowSuggestionsScreenState();
}

class _FollowSuggestionsScreenState extends State<FollowSuggestionsScreen> {
  final _followed = <int>{};

  static const _suggestions = [
    (
      name: 'Amine Kaci',
      wilaya: 'Alger',
      initial: 'A',
      color: Color(0xFF4285F4),
      reviews: 24,
      bio: 'Street food hunter 🌮'
    ),
    (
      name: 'Sara Meziane',
      wilaya: 'Blida',
      initial: 'S',
      color: Color(0xFF34A853),
      reviews: 18,
      bio: 'Café connoisseur ☕'
    ),
    (
      name: 'Youcef Hamdi',
      wilaya: 'Oran',
      initial: 'Y',
      color: Color(0xFFEA4335),
      reviews: 31,
      bio: 'Top restaurant reviewer 🍽️'
    ),
    (
      name: 'Nadia Bensalem',
      wilaya: 'Constantine',
      initial: 'N',
      color: Color(0xFFFF6B2B),
      reviews: 12,
      bio: 'Patisserie lover 🍰'
    ),
    (
      name: 'Riad Aouadi',
      wilaya: 'Tizi Ouzou',
      initial: 'R',
      color: Color(0xFF7B2FBE),
      reviews: 47,
      bio: 'Algeria food explorer 🇩🇿'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar row
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding, AppSizes.s12, 16, 0),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/feed'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.s24),

                    // Header
                    const Text(
                      'Follow food lovers\nnear you',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutral900,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: AppAnimations.normal)
                        .slideY(
                          begin: -0.1,
                          end: 0,
                          curve: AppAnimations.enter,
                          duration: AppAnimations.normal,
                        ),

                    const SizedBox(height: AppSizes.s8),

                    const Text(
                      'See what your friends are discovering and eating.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.neutral500,
                        height: 1.5,
                      ),
                    )
                        .animate(delay: 60.ms)
                        .fadeIn(duration: AppAnimations.normal),

                    const SizedBox(height: AppSizes.s8),

                    // Follow count pill
                    AnimatedContainer(
                      duration: AppAnimations.fast,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s12, vertical: AppSizes.s6),
                      decoration: BoxDecoration(
                        color: _followed.isEmpty
                            ? AppColors.neutral100
                            : AppColors.primaryLight,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        _followed.isEmpty
                            ? 'Follow at least 3 to see recommendations'
                            : '${_followed.length} followed · ${_followed.length < 3 ? "${3 - _followed.length} more to go" : "You're all set!"}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _followed.isEmpty
                              ? AppColors.neutral500
                              : AppColors.primary,
                        ),
                      ),
                    )
                        .animate(delay: 100.ms)
                        .fadeIn(duration: AppAnimations.normal),

                    const SizedBox(height: AppSizes.s24),

                    // User list
                    ..._suggestions.asMap().entries.map((e) {
                      final user = e.value;
                      final isFollowed = _followed.contains(e.key);
                      return _UserSuggestionCard(
                        name: user.name,
                        wilaya: user.wilaya,
                        initial: user.initial,
                        color: user.color,
                        reviews: user.reviews,
                        bio: user.bio,
                        followed: isFollowed,
                        index: e.key,
                        onFollow: () {
                          setState(() {
                            if (isFollowed) {
                              _followed.remove(e.key);
                            } else {
                              _followed.add(e.key);
                              HapticFeedback.lightImpact();
                            }
                          });
                        },
                      );
                    }),

                    const SizedBox(height: AppSizes.s24),
                  ],
                ),
              ),
            ),

            // CTA
            Container(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s12,
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s32),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: AppColors.neutral100)),
              ),
              child: PrimaryButton(
                label: 'Start exploring',
                onTap: () => context.go('/feed'),
                icon: Icons.explore_outlined,
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: AppAnimations.normal)
                .slideY(
                  begin: 0.15,
                  end: 0,
                  curve: AppAnimations.enter,
                  duration: AppAnimations.normal,
                ),
          ],
        ),
      ),
    );
  }
}

class _UserSuggestionCard extends StatelessWidget {
  const _UserSuggestionCard({
    required this.name,
    required this.wilaya,
    required this.initial,
    required this.color,
    required this.reviews,
    required this.bio,
    required this.followed,
    required this.index,
    required this.onFollow,
  });

  final String name;
  final String wilaya;
  final String initial;
  final Color color;
  final int reviews;
  final String bio;
  final bool followed;
  final int index;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s10),
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: followed ? AppColors.primary.withValues(alpha: 0.3) : AppColors.neutral100,
          width: followed ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.s14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bio,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 11, color: AppColors.neutral300),
                    const SizedBox(width: 2),
                    Text(
                      wilaya,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.neutral500),
                    ),
                    const SizedBox(width: AppSizes.s8),
                    const Icon(Icons.rate_review_outlined,
                        size: 11, color: AppColors.neutral300),
                    const SizedBox(width: 2),
                    Text(
                      '$reviews reviews',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.neutral500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSizes.s10),



        
          // Follow button
          GestureDetector(
            onTap: onFollow,
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              curve: AppAnimations.stateChange,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16, vertical: AppSizes.s8),
              decoration: BoxDecoration(
                color: followed ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border: Border.all(
                  color: followed ? AppColors.primary : AppColors.neutral200,
                  width: 1.5,
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: AppAnimations.fast,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: followed ? Colors.white : AppColors.neutral700,
                ),
                child: Text(followed ? 'Following' : 'Follow'),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + index * 70))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(
          begin: 0.04,
          end: 0,
          curve: AppAnimations.enter,
          duration: AppAnimations.normal,
        );
  }
}
