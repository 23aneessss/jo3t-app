import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
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
          onTap: () {},
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
              child: Image.network(
                place.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) =>
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
              onTap: () {},
              delay: 2,
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
        _SectionHeader(title: 'Photos', onSeeAll: () {}).animate(delay: const Duration(milliseconds: 100)).fadeIn(duration: AppAnimations.normal),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            itemCount: place.photos.length,
            separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s8),
            itemBuilder: (context, i) => ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.network(
                place.photos[i],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) =>
                    Container(width: 120, height: 120, color: AppColors.neutral100),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Reviews', onSeeAll: () {})
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
