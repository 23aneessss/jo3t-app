import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';

class VenueDashboardScreen extends StatelessWidget {
  const VenueDashboardScreen(
      {super.key, required this.placeId, required this.placeName});
  final String placeId;
  final String placeName;

  PlaceModel get _place =>
      MockData.places.firstWhere((p) => p.id == placeId,
          orElse: () => MockData.places.first);

  @override
  Widget build(BuildContext context) {
    final place = _place;

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.s20, AppSizes.s48, AppSizes.s20, AppSizes.s20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.s8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusFull),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified,
                                      size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('Owner',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.s8),
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${place.category.label} · ${place.wilaya}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: Row(
                children: [
                  _StatCard(
                    label: 'Score',
                    value: place.score.toStringAsFixed(1),
                    icon: Icons.star_rounded,
                    color: const Color(0xFFFFA000),
                    flex: 1,
                    animIndex: 0,
                  ),
                  const SizedBox(width: AppSizes.s10),
                  _StatCard(
                    label: 'Reviews',
                    value: '${place.reviewCount}',
                    icon: Icons.rate_review_outlined,
                    color: AppColors.primary,
                    flex: 1,
                    animIndex: 1,
                  ),
                  const SizedBox(width: AppSizes.s10),
                  _StatCard(
                    label: 'Saves',
                    value: '${(place.reviewCount * 2.4).round()}',
                    icon: Icons.bookmark_outline_rounded,
                    color: AppColors.success,
                    flex: 1,
                    animIndex: 2,
                  ),
                ],
              ),
            ),
          ),

          // Quick actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.s16, 0, AppSizes.s16, AppSizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.s12),
                    child: Text('Quick actions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900,
                        )),
                  ),
                  Row(
                    children: [
                      _ActionCard(
                        icon: Icons.photo_library_outlined,
                        label: 'Manage\nlisting',
                        onTap: () => context.push(
                          '/manage-venue/$placeId',
                          extra: {'name': place.name},
                        ),
                        animIndex: 0,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      _ActionCard(
                        icon: Icons.rate_review_outlined,
                        label: 'All\nreviews',
                        onTap: () => context.push(
                          '/place/$placeId/reviews',
                          extra: {
                            'name': place.name,
                            'averageScore': place.score,
                            'reviewCount': place.reviewCount,
                          },
                        ),
                        animIndex: 1,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      _ActionCard(
                        icon: Icons.visibility_outlined,
                        label: 'View\nlisting',
                        onTap: () => context.push('/place/$placeId'),
                        animIndex: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recent reviews
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.s16, 0, AppSizes.s16, AppSizes.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent reviews',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900)),
                  GestureDetector(
                    onTap: () => context.push(
                      '/place/$placeId/reviews',
                      extra: {
                        'name': place.name,
                        'averageScore': place.score,
                        'reviewCount': place.reviewCount,
                      },
                    ),
                    child: const Text('See all',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final review = _mockRecentReviews[i];
                return _ReviewRow(review: review, animIndex: i)
                    .animate(
                        delay:
                            Duration(milliseconds: 100 + i * 60))
                    .fadeIn(duration: AppAnimations.normal)
                    .slideX(begin: 0.05, end: 0);
              },
              childCount: _mockRecentReviews.length,
            ),
          ),

          // Score trend
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s16),
              child: _ScoreTrendCard(score: place.score)
                  .animate(delay: 400.ms)
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(begin: 0.06, end: 0),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }

  static const _mockRecentReviews = [
    (name: 'Sara B.', score: 9.0, text: 'Incroyable, meilleure adresse de la ville!', timeAgo: '2h'),
    (name: 'Karim M.', score: 7.5, text: 'Bon rapport qualité/prix, service sympa.', timeAgo: '1d'),
    (name: 'Nadia A.', score: 8.0, text: 'Très bon, je reviendrai sûrement.', timeAgo: '3d'),
  ];
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.flex,
    required this.animIndex,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final int flex;
  final int animIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s14),
        decoration: BoxDecoration(
          color: AppColors.neutral0,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.neutral100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppSizes.s8),
            Text(value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                )),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.neutral500)),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: animIndex * 60))
          .fadeIn(duration: AppAnimations.normal)
          .scale(
            begin: const Offset(0.92, 0.92),
            end: const Offset(1, 1),
            duration: AppAnimations.normal,
            curve: AppAnimations.overshoot,
          ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.animIndex});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int animIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            color: AppColors.neutral0,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral100),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(height: AppSizes.s8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral700,
                    height: 1.3,
                  )),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 200 + animIndex * 60))
            .fadeIn(duration: AppAnimations.normal)
            .slideY(begin: 0.08, end: 0),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review, required this.animIndex});
  final ({String name, double score, String text, String timeAgo}) review;
  final int animIndex;

  Color get _scoreColor {
    if (review.score >= 8.5) return AppColors.success;
    if (review.score >= 7) return const Color(0xFF2ECC71);
    if (review.score >= 5) return const Color(0xFFF39C12);
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSizes.s16, 0, AppSizes.s16, AppSizes.s10),
      padding: const EdgeInsets.all(AppSizes.s14),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(review.name[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 15)),
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(review.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.neutral900)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _scoreColor.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(review.score.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _scoreColor)),
                    ),
                    const SizedBox(width: AppSizes.s8),
                    Text(review.timeAgo,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.neutral300)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(review.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.neutral500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreTrendCard extends StatelessWidget {
  const _ScoreTrendCard({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up_rounded,
                  color: AppColors.success, size: 18),
              SizedBox(width: AppSizes.s8),
              Text('Score trend (last 30 days)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  )),
            ],
          ),
          const SizedBox(height: AppSizes.s16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final (i, h) in [
                0.55, 0.60, 0.58, 0.70, 0.72, 0.68, 0.75,
                0.78, 0.74, 0.82, 0.85, 0.80, 0.88, score / 10,
              ].indexed)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400 + i * 30),
                      curve: AppAnimations.enter,
                      height: 80 * h,
                      decoration: BoxDecoration(
                        color: i == 13
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('30 days ago',
                  style: TextStyle(
                      fontSize: 10, color: AppColors.neutral300)),
              Row(
                children: [
                  const Icon(Icons.arrow_upward_rounded,
                      size: 12, color: AppColors.success),
                  Text('+0.${(score * 10).round() % 10}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Text('Today',
                  style: TextStyle(
                      fontSize: 10, color: AppColors.neutral300)),
            ],
          ),
        ],
      ),
    );
  }
}
