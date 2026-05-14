import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/constants/app_animations.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/review_card.dart';
import '../../review/domain/repositories/review_repository.dart';
import '../../review/presentation/providers/review_providers.dart';

class AllReviewsScreen extends ConsumerStatefulWidget {
  const AllReviewsScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.averageScore,
    required this.reviewCount,
  });

  final String placeId;
  final String placeName;
  final double averageScore;
  final int reviewCount;

  @override
  ConsumerState<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends ConsumerState<AllReviewsScreen> {
  ReviewSortOrder _sortOrder = ReviewSortOrder.newest;
  final Map<String, String> _ownerReplies = {};

  void _showReplySheet(String reviewId) {
    final controller = TextEditingController(text: _ownerReplies[reviewId]);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(
              AppSizes.s20, AppSizes.s16, AppSizes.s20, AppSizes.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s16),
              Text(
                'Respond as owner',
                style: TextStyle(
                  color: AppColors.neutral900,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.s4),
              Text(
                'Your response will be visible publicly below the review.',
                style: TextStyle(color: AppColors.neutral500, fontSize: 13),
              ),
              const SizedBox(height: AppSizes.s16),
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Thank you for your feedback…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  counterStyle: const TextStyle(
                      fontSize: 11, color: AppColors.neutral300),
                ),
              ),
              const SizedBox(height: AppSizes.s12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;
                    setState(() => _ownerReplies[reviewId] = text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Post response',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(placeReviewsProvider(
      (placeId: widget.placeId, sortOrder: _sortOrder),
    ));

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.neutral0,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.neutral900,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.placeName,
                  style: TextStyle(
                    color: AppColors.neutral500,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Stats header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.neutral0,
              padding: const EdgeInsets.fromLTRB(
                AppSizes.s20,
                AppSizes.s16,
                AppSizes.s20,
                AppSizes.s20,
              ),
              child: Row(
                children: [
                  // Score
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            widget.averageScore.toStringAsFixed(1),
                            style: TextStyle(
                              color: AppColors.neutral900,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: AppSizes.s4),
                          Text(
                            '/10',
                            style: TextStyle(
                              color: AppColors.neutral500,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.s4),
                      Text(
                        '${widget.reviewCount} reviews',
                        style: TextStyle(
                          color: AppColors.neutral500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSizes.s24),
                  // Score bars
                  Expanded(child: _ScoreBars(score: widget.averageScore)),
                ],
              ),
            ).animate().fadeIn(duration: AppAnimations.fast),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Container(height: AppSizes.s8, color: AppColors.neutral100),
          ),

          // Sort chips
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.neutral0,
              padding: const EdgeInsets.fromLTRB(
                AppSizes.s16,
                AppSizes.s12,
                AppSizes.s16,
                AppSizes.s12,
              ),
              child: Row(
                children: [
                  Text(
                    'Sort by:',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  ...ReviewSortOrder.values.map((order) {
                    final isActive = _sortOrder == order;
                    final label = switch (order) {
                      ReviewSortOrder.newest => 'Newest',
                      ReviewSortOrder.highest => 'Highest',
                      ReviewSortOrder.lowest => 'Lowest',
                    };
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.s8),
                      child: GestureDetector(
                        onTap: () => setState(() => _sortOrder = order),
                        child: AnimatedContainer(
                          duration: AppAnimations.fast,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s12,
                            vertical: AppSizes.s6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.neutral100,
                            borderRadius:
                                BorderRadius.circular(AppSizes.s20),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.neutral0
                                  : AppColors.neutral700,
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Reviews list
          reviewsAsync.when(
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ReviewSkeleton(),
                childCount: 5,
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorWidget(
                message: 'Could not load reviews',
                onRetry: () => ref.invalidate(placeReviewsProvider),
              ),
            ),
            data: (reviews) {
              if (reviews.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyReviewsState(
                    onWrite: () => Navigator.of(context).pop(),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final review = reviews[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.s16,
                        AppSizes.s12,
                        AppSizes.s16,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReviewCard(
                            authorName: review.userName,
                            authorWilaya: '',
                            authorInitial: review.userName.isNotEmpty
                                ? review.userName[0]
                                : '?',
                            score: review.score,
                            text: review.text,
                            timeAgo: formatTimeAgo(review.createdAt),
                            photos: review.photos,
                            animationIndex: index,
                          ),
                          if (_ownerReplies.containsKey(review.id))
                            _OwnerReply(text: _ownerReplies[review.id]!,
                                venueName: widget.placeName),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: AppSizes.s8, left: AppSizes.s4),
                            child: GestureDetector(
                              onTap: () => _showReplySheet(review.id),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.reply_rounded,
                                      size: 14, color: AppColors.neutral400),
                                  const SizedBox(width: 4),
                                  Text(
                                    _ownerReplies.containsKey(review.id)
                                        ? 'Edit response'
                                        : 'Respond as owner',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.neutral500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(
                                milliseconds: index * AppAnimations.staggerDelay.inMilliseconds),
                          )
                          .slideY(begin: 0.06, end: 0),
                    );
                  },
                  childCount: reviews.length,
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s32)),
        ],
      ),
    );
  }

}

class _ScoreBars extends StatelessWidget {
  const _ScoreBars({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final range in [
          (label: '9-10', fraction: score >= 9 ? 0.7 : 0.1),
          (label: '7-8', fraction: score >= 7 ? 0.5 : 0.15),
          (label: '5-6', fraction: 0.15),
          (label: '1-4', fraction: 0.05),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s6),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    range.label,
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: range.fraction,
                      backgroundColor: AppColors.neutral100,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReviewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.s16, AppSizes.s12, AppSizes.s16, 0),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(AppSizes.s16),
        ),
      ),
    );
  }
}
