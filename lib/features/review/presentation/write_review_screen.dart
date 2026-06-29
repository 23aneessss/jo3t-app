import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/photo_picker.dart';
import '../../../shared/widgets/primary_button.dart';
import 'providers/review_providers.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  const WriteReviewScreen({super.key, required this.placeId});

  final String placeId;

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int? _score;
  final _controller = TextEditingController();
  List<String> _photoPaths = [];

  PlaceModel get _place =>
      MockData.places.firstWhere((p) => p.id == widget.placeId,
          orElse: () => MockData.places.first);

  String get _scoreLabel {
    if (_score == null) return 'Tap a score';
    if (_score! <= 2) return 'Very disappointing';
    if (_score! <= 4) return 'Disappointing';
    if (_score! <= 5) return 'Decent';
    if (_score! <= 6) return 'Good';
    if (_score! <= 7) return 'Very good';
    if (_score! <= 8) return 'Great';
    if (_score! <= 9) return 'Excellent';
    return 'Exceptional';
  }

  bool get _canSubmit =>
      _score != null && _controller.text.trim().length >= 20;

  Future<void> _submit() async {
    final notifier = ref.read(submitReviewNotifierProvider.notifier);
    final success = await notifier.submit(
      placeId: widget.placeId,
      score: _score!.toDouble(),
      text: _controller.text.trim(),
      photoPaths: _photoPaths,
    );
    if (success && mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review submitted — thanks!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(submitReviewNotifierProvider);
    final isSubmitting = submitState.isLoading;
    final place = _place;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Write a review',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            Text(
              place.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.neutral500),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score section
            _Section(
              title: 'Your score',
              animationDelay: 0,
              child: Column(
                children: [
                  _ScorePicker(
                    selected: _score,
                    onSelect: (s) => setState(() => _score = s),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  AnimatedSwitcher(
                    duration: AppAnimations.fast,
                    child: Text(
                      _scoreLabel,
                      key: ValueKey(_score),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _score != null
                            ? AppColors.scoreColor(_score!.toDouble())
                            : AppColors.neutral300,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s24),

            // Review text
            _Section(
              title: 'Your review',
              subtitle: 'Minimum 20 characters',
              animationDelay: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    maxLines: 6,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText:
                          'What did you think? Food, atmosphere, service…',
                      alignLabelWithHint: true,
                      counterStyle: const TextStyle(
                          fontSize: 11, color: AppColors.neutral300),
                    ),
                  ),
                  if (_controller.text.isNotEmpty &&
                      _controller.text.trim().length < 20)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSizes.s4),
                      child: Text(
                        '${20 - _controller.text.trim().length} more characters to go',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.s24),

            // Photo upload
            _Section(
              title: 'Add photos',
              subtitle: 'Optional · up to 5',
              animationDelay: 2,
              child: PhotoPicker(
                maxPhotos: 5,
                onChanged: (paths) => setState(() => _photoPaths = paths),
              ),
            ),

            const SizedBox(height: AppSizes.s32),

            PrimaryButton(
              label: 'Submit review',
              onTap: _canSubmit && !isSubmitting ? _submit : null,
              loading: isSubmitting,
            )
                .animate(delay: const Duration(milliseconds: 300))
                .fadeIn(duration: AppAnimations.normal)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),

            const SizedBox(height: AppSizes.s32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    required this.animationDelay,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: AppSizes.s8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.neutral300,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.s12),
        child,
      ],
    )
        .animate(
            delay: Duration(milliseconds: 60 + animationDelay * 80))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}

class _ScorePicker extends StatelessWidget {
  const _ScorePicker({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(10, (i) {
        final score = i + 1;
        final isSelected = selected == score;
        final color = AppColors.scoreColor(score.toDouble());

        return GestureDetector(
          onTap: () => onSelect(score),
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            curve: AppAnimations.stateChange,
            width: isSelected ? AppSizes.scoreBadgeLg : AppSizes.scoreBadgeSm,
            height: isSelected ? AppSizes.scoreBadgeLg : AppSizes.scoreBadgeSm,
            decoration: BoxDecoration(
              color: isSelected ? color : AppColors.neutral100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : AppColors.neutral200,
                width: isSelected ? 0 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)]
                  : null,
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: AppAnimations.fast,
                style: TextStyle(
                  fontSize: isSelected ? 13 : 11,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.neutral500,
                ),
                child: Text('$score'),
              ),
            ),
          ),
        )
            .animate(delay: Duration(milliseconds: i * 30))
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: AppAnimations.normal,
              curve: AppAnimations.overshoot,
            )
            .fadeIn(duration: AppAnimations.fast);
      }),
    );
  }
}

