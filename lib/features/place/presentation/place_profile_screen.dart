import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/score_ring.dart';
import '../../../shared/widgets/wilaya_badge.dart';

class PlaceProfileScreen extends StatefulWidget {
  const PlaceProfileScreen({super.key, required this.placeId});
  final String placeId;

  @override
  State<PlaceProfileScreen> createState() => _PlaceProfileScreenState();
}

class _PlaceProfileScreenState extends State<PlaceProfileScreen> {
  bool _saved = false;
  bool _checkedIn = false;
  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  PlaceModel get _place =>
      MockData.places.firstWhere((p) => p.id == widget.placeId,
          orElse: () => MockData.places.first);

  static const _expandedHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() => _scrollOffset = _scrollController.offset);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isCollapsed => _scrollOffset > _expandedHeight - 80;

  void _showShareSheet(BuildContext context, PlaceModel place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = _place;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context, place),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, place),
                _buildScoreSection(context, place),
                _buildQuickActions(context, place),
                _buildGallery(place),
                _buildRatingBreakdown(context, place),
                _buildReviewsSection(context),
                _buildMutualRecs(context),
                _buildSimilarPlaces(context, place),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context, place),
    );
  }

  Widget _buildAppBar(BuildContext context, PlaceModel place) {
    return SliverAppBar(
      expandedHeight: _expandedHeight,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: _CircleBtn(
        icon: Icons.arrow_back,
        onTap: () => context.pop(),
      ),
      actions: [
        _CircleBtn(
          icon: _saved ? Icons.bookmark : Icons.bookmark_outline,
          iconColor: _saved ? AppColors.primary : null,
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _saved = !_saved);
          },
        ),
        const SizedBox(width: 6),
        _CircleBtn(
          icon: Icons.share_outlined,
          onTap: () => _showShareSheet(context, place),
        ),
        const SizedBox(width: AppSizes.s8),
      ],
      title: _isCollapsed
          ? Text(
              place.name,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900),
            )
                .animate()
                .fadeIn(duration: AppAnimations.fast)
                .slideY(begin: 0.2, end: 0, duration: AppAnimations.fast)
          : null,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place-cover-${place.id}',
              child: CachedNetworkImage(
                imageUrl: place.coverUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.neutral200,
                  highlightColor: AppColors.neutral100,
                  child: Container(color: AppColors.neutral200),
                ),
                errorWidget: (context, url, error) =>
                    Container(color: AppColors.neutral100),
              ),
            ),
            // Bottom gradient
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1.0],
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            // Status pill on image
            Positioned(
              bottom: AppSizes.s16,
              left: AppSizes.screenHorizontalPadding,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s12, vertical: 6),
                decoration: BoxDecoration(
                  color: place.isOpen
                      ? AppColors.success.withValues(alpha: 0.9)
                      : AppColors.error.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      place.isOpen
                          ? 'Open · until ${place.openUntil}'
                          : 'Closed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                      delay: const Duration(milliseconds: 200),
                      duration: AppAnimations.normal)
                  .slideX(begin: -0.1, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s20,
          AppSizes.screenHorizontalPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 26,
                  color: AppColors.neutral900,
                ),
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal)
              .slideY(begin: 0.15, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),

          const SizedBox(height: AppSizes.s8),

          Row(
            children: [
              _Tag(label: place.category.label),
              const SizedBox(width: AppSizes.s8),
              WilayaBadge(wilaya: '${place.neighborhood}, ${place.wilaya}'),
              const SizedBox(width: AppSizes.s8),
              _Tag(label: place.priceRange.label, subtle: true),
            ],
          )
              .animate(delay: const Duration(milliseconds: 80))
              .fadeIn(duration: AppAnimations.normal),
        ],
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s24,
          AppSizes.screenHorizontalPadding, 0),
      child: Row(
        children: [
          ScoreRing(score: place.score, size: 96, strokeWidth: 7),
          const SizedBox(width: AppSizes.s24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _scoreLabel(place.score),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.scoreColor(place.score),
                  ),
                )
                    .animate(delay: const Duration(milliseconds: 400))
                    .fadeIn(duration: AppAnimations.normal)
                    .slideX(begin: 0.1, end: 0),

                const SizedBox(height: 4),

                Text(
                  '${place.reviewCount} community reviews',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
                    .animate(delay: const Duration(milliseconds: 480))
                    .fadeIn(duration: AppAnimations.normal),

                const SizedBox(height: AppSizes.s12),

                // Stars representation
                Row(
                  children: List.generate(10, (i) {
                    final filled = (i + 1) <= place.score.floor();
                    final half = !filled && (i + 0.5) < place.score;
                    return Icon(
                      half
                          ? Icons.star_half_rounded
                          : filled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                      size: 14,
                      color: filled || half
                          ? AppColors.scoreColor(place.score)
                          : AppColors.neutral200,
                    )
                        .animate(
                            delay: Duration(
                                milliseconds: 500 + i * 40))
                        .scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: AppAnimations.overshoot,
                          duration: AppAnimations.fast,
                        );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s20,
          AppSizes.screenHorizontalPadding, 0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _ActionBtn(
              icon: Icons.directions_outlined,
              label: 'Directions',
              primary: true,
              onTap: () {},
              delay: 0,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: _ActionBtn(
              icon: Icons.phone_outlined,
              label: 'Call',
              onTap: () {},
              delay: 1,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: _ActionBtn(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () => _showShareSheet(context, place),
              delay: 2,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: _CheckInBtn(
              checkedIn: _checkedIn,
              onTap: () {
                setState(() => _checkedIn = !_checkedIn);
                if (!_checkedIn) return;
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Checked in to ${place.name}! 📍'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(PlaceModel place) {
    if (place.photos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Photos',
          onSeeAll: () => context.push(
            '/place/${place.id}/gallery',
            extra: {
              'photos': place.photos,
              'name': place.name,
              'index': 0,
            },
          ),
        ).animate(delay: const Duration(milliseconds: 100)).fadeIn(duration: AppAnimations.normal),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            itemCount: place.photos.length,
            separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s8),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => context.push(
                '/place/${place.id}/gallery',
                extra: {
                  'photos': place.photos,
                  'name': place.name,
                  'index': i,
                },
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.network(
                  place.photos[i],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) =>
                      Container(width: 120, height: 120, color: AppColors.neutral100),
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: 80 * i))
                .fadeIn(duration: AppAnimations.normal)
                .scale(
                  begin: const Offset(0.88, 0.88),
                  end: const Offset(1, 1),
                  curve: AppAnimations.overshoot,
                  duration: AppAnimations.normal,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBreakdown(BuildContext context, PlaceModel place) {
    final breakdown = [
      (label: '9–10', fraction: 0.48, count: (place.reviewCount * 0.48).round()),
      (label: '7–8', fraction: 0.33, count: (place.reviewCount * 0.33).round()),
      (label: '5–6', fraction: 0.12, count: (place.reviewCount * 0.12).round()),
      (label: '1–4', fraction: 0.07, count: (place.reviewCount * 0.07).round()),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s24,
          AppSizes.screenHorizontalPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rating breakdown',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          ...breakdown.asMap().entries.map((e) => _RatingBar(
                label: e.value.label,
                fraction: e.value.fraction,
                count: e.value.count,
                color: e.key == 0
                    ? AppColors.scoreTop
                    : e.key == 1
                        ? AppColors.scoreHigh
                        : e.key == 2
                            ? AppColors.scoreMid
                            : AppColors.scoreLow,
                animationDelay: e.key,
              )),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final place = _place;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Reviews',
          onSeeAll: () => context.push(
            '/place/${place.id}/reviews',
            extra: {
              'name': place.name,
              'averageScore': place.score,
              'reviewCount': place.reviewCount,
            },
          ),
        )
            .animate(delay: const Duration(milliseconds: 100))
            .fadeIn(duration: AppAnimations.normal),
        ...MockData.reviews.take(3).toList().asMap().entries.map(
              (e) => ReviewCard(
                authorName: e.value.authorName,
                authorWilaya: e.value.authorWilaya,
                authorInitial: e.value.authorInitial,
                score: e.value.score,
                text: e.value.text,
                timeAgo: e.value.timeAgo,
                photos: e.value.photos,
                animationIndex: e.key,
              ),
            ),
      ],
    );
  }

  Widget _buildMutualRecs(BuildContext context) {
    const recs = [
      (name: 'Amine K.', initial: 'A', score: 9.0, action: 'reviewed', timeAgo: '2d ago',
       text: 'Best couscous in Blida! The lamb was perfectly cooked.'),
      (name: 'Sara M.', initial: 'S', score: 0.0, action: 'saved', timeAgo: '1w ago', text: ''),
      (name: 'Nadia T.', initial: 'N', score: 9.5, action: 'reviewed', timeAgo: '3w ago',
       text: 'Exceptional cooking, like being at a family table.'),
    ];
    const reviewers = ['Amine K.', 'Nadia T.'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenHorizontalPadding, AppSizes.s8,
        AppSizes.screenHorizontalPadding, AppSizes.s4,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                const Icon(Icons.people_outline_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: AppSizes.s6),
                const Text(
                  'People you follow',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s12),
            // Avatar row + summary
            Row(
              children: [
                // Stacked avatars
                SizedBox(
                  width: recs.length * 24.0 + 12,
                  height: 32,
                  child: Stack(
                    children: recs.asMap().entries.map((e) {
                      return Positioned(
                        left: e.key * 20.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.7),
                                AppColors.primaryDark,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: const Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              e.value.initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                Expanded(
                  child: Text(
                    '${reviewers.join(', ')} and 1 other know this place',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s12),
            // Latest friend review snippet
            Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.7),
                          AppColors.primaryDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.s8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Amine K.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutral900,
                              ),
                            ),
                            const SizedBox(width: AppSizes.s6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.scoreColor(9.0)
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusFull),
                              ),
                              child: Text(
                                '9.0/10',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scoreColor(9.0),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '2d ago',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.neutral300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Best couscous in Blida! The lamb was perfectly cooked.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
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
            ),
          ],
        ),
      ),
    )
        .animate(delay: 150.ms)
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.06, end: 0, curve: AppAnimations.enter, duration: AppAnimations.normal);
  }

  Widget _buildSimilarPlaces(BuildContext context, PlaceModel place) {
    final similar = MockData.places
        .where((p) => p.id != place.id && p.category == place.category)
        .take(4)
        .toList();
    if (similar.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Similar places', onSeeAll: () {})
            .animate(delay: const Duration(milliseconds: 100))
            .fadeIn(duration: AppAnimations.normal),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            itemCount: similar.length,
            separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s12),
            itemBuilder: (context, i) => _SimilarPlaceCard(
              place: similar[i],
              index: i,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context, PlaceModel place) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/review/new/${place.id}'),
      backgroundColor: AppColors.primary,
      elevation: 4,
      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
      label: const Text(
        'Write a review',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    )
        .animate(delay: const Duration(milliseconds: 500))
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          curve: AppAnimations.overshoot,
          duration: AppAnimations.normal,
        )
        .fadeIn(duration: AppAnimations.fast);
  }

  String _scoreLabel(double s) {
    if (s >= 9.5) return 'Exceptional ✨';
    if (s >= 9) return 'Excellent';
    if (s >= 8) return 'Great';
    if (s >= 7) return 'Very good';
    if (s >= 6) return 'Good';
    if (s >= 5) return 'Decent';
    return 'Disappointing';
  }
}

// ---- Local widgets ----

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap, this.iconColor});
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18,
            color: iconColor ?? Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, this.subtle = false});
  final String label;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: subtle ? Colors.transparent : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: subtle
            ? Border.all(color: AppColors.neutral200)
            : Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: subtle ? AppColors.neutral500 : AppColors.primary,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s24,
          AppSizes.s8, AppSizes.s12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral900,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'See all',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.label,
    required this.fraction,
    required this.count,
    required this.color,
    required this.animationDelay,
  });
  final String label;
  final double fraction;
  final int count;
  final Color color;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral500,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              child: Container(
                height: 8,
                color: AppColors.neutral100,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: Duration(milliseconds: 800 + animationDelay * 100),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => FractionallySizedBox(
                    widthFactor: v,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          SizedBox(
            width: 32,
            child: Text(
              '${(fraction * 100).round()}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      )
          .animate(delay: Duration(milliseconds: 200 + animationDelay * 80))
          .fadeIn(duration: AppAnimations.normal)
          .slideX(begin: 0.05, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
    );
  }
}

class _SimilarPlaceCard extends StatefulWidget {
  const _SimilarPlaceCard({required this.place, required this.index});
  final PlaceModel place;
  final int index;

  @override
  State<_SimilarPlaceCard> createState() => _SimilarPlaceCardState();
}

class _SimilarPlaceCardState extends State<_SimilarPlaceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/place/${place.id}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: AppAnimations.micro,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusLg)),
                child: Hero(
                  tag: 'place-cover-${place.id}-similar',
                  child: Image.network(
                    place.coverUrl,
                    width: 160,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                        width: 160,
                        height: 110,
                        color: AppColors.neutral100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.s10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 11, color: AppColors.neutral300),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            place.wilaya,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.neutral500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.scoreColor(place.score)
                                .withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: Text(
                            place.score.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.scoreColor(place.score),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.s6),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: place.isOpen
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: place.isOpen
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
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
        .animate(delay: Duration(milliseconds: 100 + widget.index * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(
          begin: 0.08,
          end: 0,
          curve: AppAnimations.enter,
          duration: AppAnimations.normal,
        );
  }
}

class _ActionBtn extends StatefulWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.delay,
    this.primary = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int delay;
  final bool primary;

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: AppAnimations.micro,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          height: 52,
          decoration: BoxDecoration(
            color: widget.primary
                ? (_pressed ? AppColors.primaryDark : AppColors.primary)
                : (_pressed ? AppColors.neutral100 : AppColors.neutral50),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: widget.primary
                ? null
                : Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  size: 17,
                  color: widget.primary
                      ? Colors.white
                      : AppColors.neutral700),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.primary ? Colors.white : AppColors.neutral700,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 160 + widget.delay * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.2, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}

// ---- Check-In Button ----

class _CheckInBtn extends StatefulWidget {
  const _CheckInBtn({required this.checkedIn, required this.onTap});
  final bool checkedIn;
  final VoidCallback onTap;

  @override
  State<_CheckInBtn> createState() => _CheckInBtnState();
}

class _CheckInBtnState extends State<_CheckInBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: AppAnimations.micro,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          height: 52,
          decoration: BoxDecoration(
            color: widget.checkedIn
                ? AppColors.success.withValues(alpha: 0.12)
                : AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: widget.checkedIn ? AppColors.success : AppColors.neutral200,
              width: widget.checkedIn ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: AppAnimations.fast,
                child: Icon(
                  widget.checkedIn
                      ? Icons.check_circle_rounded
                      : Icons.add_location_alt_outlined,
                  key: ValueKey(widget.checkedIn),
                  size: 18,
                  color: widget.checkedIn ? AppColors.success : AppColors.neutral700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.checkedIn ? 'Visited!' : 'Check In',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.checkedIn ? AppColors.success : AppColors.neutral700,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: const Duration(milliseconds: 340))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.2, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}

// ---- Share Sheet ----

class _ShareSheet extends StatefulWidget {
  const _ShareSheet({required this.place});
  final PlaceModel place;

  @override
  State<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<_ShareSheet> {
  bool _linkCopied = false;

  static const _shareOptions = [
    (icon: Icons.link_rounded, label: 'Copy link', color: Color(0xFF4A90D9)),
    (icon: Icons.chat_bubble_outline_rounded, label: 'WhatsApp', color: Color(0xFF25D366)),
    (icon: Icons.camera_alt_outlined, label: 'Instagram', color: Color(0xFFE1306C)),
    (icon: Icons.send_rounded, label: 'Messenger', color: Color(0xFF0084FF)),
  ];

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenHorizontalPadding, AppSizes.s16,
        AppSizes.screenHorizontalPadding, AppSizes.s48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          // Place preview
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.network(
                  place.coverUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) =>
                      Container(width: 56, height: 56, color: AppColors.neutral100),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place.category.label} · ${place.wilaya}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          '${place.score}/10',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal),
          const SizedBox(height: AppSizes.s24),
          // Share options grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _shareOptions.asMap().entries.map((entry) {
              final opt = entry.value;
              final isCopy = entry.key == 0;
              return GestureDetector(
                onTap: () {
                  if (isCopy) {
                    setState(() => _linkCopied = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _linkCopied = false);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: AppAnimations.fast,
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (isCopy && _linkCopied)
                            ? AppColors.success.withValues(alpha: 0.12)
                            : opt.color.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        (isCopy && _linkCopied)
                            ? Icons.check_rounded
                            : opt.icon,
                        color: (isCopy && _linkCopied)
                            ? AppColors.success
                            : opt.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s6),
                    Text(
                      (isCopy && _linkCopied) ? 'Copied!' : opt.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral700,
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: entry.key * 50))
                  .fadeIn(duration: AppAnimations.normal)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: AppAnimations.overshoot,
                    duration: AppAnimations.normal,
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
