import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'score_badge.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    required this.authorName,
    required this.authorWilaya,
    required this.authorInitial,
    required this.score,
    required this.text,
    required this.timeAgo,
    this.photos = const [],
    this.animationIndex = 0,
  });

  final String authorName;
  final String authorWilaya;
  final String authorInitial;
  final double score;
  final String text;
  final String timeAgo;
  final List<String> photos;
  final int animationIndex;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;
  static const _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final delay = AppAnimations.staggerDelay * widget.animationIndex;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenHorizontalPadding,
        vertical: AppSizes.s4,
      ),
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: AppSizes.avatarMd / 2,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  widget.authorInitial,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.authorName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: AppColors.neutral300),
                        const SizedBox(width: 2),
                        Text(
                          widget.authorWilaya,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: AppSizes.s8),
                        Text(
                          '· ${widget.timeAgo}',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ScoreBadge(
                score: widget.score,
                size: ScoreBadgeSize.small,
                animate: true,
                delay: delay + const Duration(milliseconds: 100),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s12),

          // Review text
          AnimatedCrossFade(
            duration: AppAnimations.normal,
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          // "Read more" toggle — only if text overflows
          if (widget.text.length > 120)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSizes.s4),
                child: Text(
                  _expanded ? 'Show less' : 'Read more',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Photo strip
          if (widget.photos.isNotEmpty) ...[
            const SizedBox(height: AppSizes.s12),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.photos.length,
                separatorBuilder: (context, i) =>
                    const SizedBox(width: AppSizes.s8),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: CachedNetworkImage(
                    imageUrl: widget.photos[i],
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(width: 64, height: 64, color: AppColors.neutral100),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: AppAnimations.normal, curve: AppAnimations.enter)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppAnimations.normal,
          curve: AppAnimations.enter,
        );
  }
}
