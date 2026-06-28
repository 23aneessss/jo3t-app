import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';
import 'widgets/onboarding_art.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      art: DiscoverArt(),
      title: 'Discover real places',
      subtitle:
          'Find the best restaurants, cafés, and hidden gems across all 48 wilayas — recommended by real Algerians.',
    ),
    _OnboardingPage(
      art: ReviewsArt(),
      title: 'Honest community reviews',
      subtitle:
          'No sponsored posts. No fake ratings. Just authentic reviews from people like you.',
    ),
    _OnboardingPage(
      art: WilayaArt(),
      title: 'Your wilaya, your feed',
      subtitle:
          'Get hyper-local picks from your city first. Then explore the whole country.',
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppAnimations.medium,
        curve: AppAnimations.enter,
      );
    } else {
      context.go('/auth');
    }
  }

  void _skip() => context.go('/auth');

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding,
                    vertical: AppSizes.s12),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) => _pages[i],
              ),
            ),

            // Dots + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  0,
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s32),
              child: Column(
                children: [
                  _DotsIndicator(
                    count: _pages.length,
                    current: _currentPage,
                  ),
                  const SizedBox(height: AppSizes.s24),
                  PrimaryButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Get started'
                        : 'Continue',
                    onTap: _next,
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.art,
    required this.title,
    required this.subtitle,
  });

  final Widget art;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s32, vertical: AppSizes.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          art
              .animate()
              .scale(
                begin: const Offset(0.82, 0.82),
                end: const Offset(1, 1),
                duration: AppAnimations.medium,
                curve: AppAnimations.overshoot,
              )
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s48),

          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  color: AppColors.neutral900,
                ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 80))
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                begin: 0.15,
                end: 0,
                duration: AppAnimations.normal,
                curve: AppAnimations.enter,
              ),

          const SizedBox(height: AppSizes.s16),

          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.neutral500,
                  height: 1.7,
                ),
            textAlign: TextAlign.center,
          )
              .animate(delay: const Duration(milliseconds: 160))
              .fadeIn(duration: AppAnimations.normal),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.stateChange,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.neutral200,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
        );
      }),
    );
  }
}
