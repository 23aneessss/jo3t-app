import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'score_badge.dart';

class PlaceCardHorizontal extends StatefulWidget {
  const PlaceCardHorizontal({
    super.key,
    required this.name,
    required this.category,
    required this.wilaya,
    required this.score,
    required this.imageUrl,
    this.distance,
    required this.onTap,
    this.animationIndex = 0,
  });

  final String name;
  final String category;
  final String wilaya;
  final double score;
  final String imageUrl;
  final String? distance;
  final VoidCallback onTap;
  final int animationIndex;

  @override
  State<PlaceCardHorizontal> createState() => _PlaceCardHorizontalState();
}

class _PlaceCardHorizontalState extends State<PlaceCardHorizontal> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final delay = AppAnimations.staggerDelay * widget.animationIndex;

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
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontalPadding,
            vertical: AppSizes.s4,
          ),
          padding: const EdgeInsets.all(AppSizes.s12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.network(
                  widget.imageUrl,
                  width: AppSizes.placeCardImageSize,
                  height: AppSizes.placeCardImageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, _) => Container(
                    width: AppSizes.placeCardImageSize,
                    height: AppSizes.placeCardImageSize,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.neutral100, AppColors.neutral50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      '${widget.category} · ${widget.wilaya}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: AppSizes.s8),
                    Row(
                      children: [
                        ScoreBadge(
                          score: widget.score,
                          size: ScoreBadgeSize.small,
                          animate: true,
                          delay: delay + const Duration(milliseconds: 120),
                        ),
                        if (widget.distance != null) ...[
                          const SizedBox(width: AppSizes.s8),
                          Text(
                            widget.distance!,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: AppAnimations.normal, curve: AppAnimations.enter)
        .slideY(
          begin: AppAnimations.cardEntryOffsetY / 100,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}

class PlaceCardVertical extends StatefulWidget {
  const PlaceCardVertical({
    super.key,
    required this.name,
    required this.category,
    required this.score,
    required this.imageUrl,
    this.distance,
    required this.onTap,
    this.animationIndex = 0,
  });

  final String name;
  final String category;
  final double score;
  final String imageUrl;
  final String? distance;
  final VoidCallback onTap;
  final int animationIndex;

  @override
  State<PlaceCardVertical> createState() => _PlaceCardVerticalState();
}

class _PlaceCardVerticalState extends State<PlaceCardVertical> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final delay = AppAnimations.staggerDelay * widget.animationIndex;

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
        child: Container(
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, _) => Container(
                      color: AppColors.neutral100,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSizes.s8,
                  right: AppSizes.s8,
                  child: ScoreBadge(
                    score: widget.score,
                    size: ScoreBadgeSize.small,
                    animate: true,
                    delay: delay + const Duration(milliseconds: 160),
                  ),
                ),
                Positioned(
                  left: AppSizes.s12,
                  right: AppSizes.s12,
                  bottom: AppSizes.s12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSizes.s4),
                      Row(
                        children: [
                          _chip(widget.category),
                          if (widget.distance != null) ...[
                            const SizedBox(width: AppSizes.s8),
                            _chip(widget.distance!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: AppAnimations.normal, curve: AppAnimations.enter)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s8, vertical: AppSizes.s4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
