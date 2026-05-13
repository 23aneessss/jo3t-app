import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/score_badge.dart';
import '../../../shared/widgets/wilaya_badge.dart';

class PlaceProfileScreen extends StatefulWidget {
  const PlaceProfileScreen({super.key, required this.placeId});

  final String placeId;

  @override
  State<PlaceProfileScreen> createState() => _PlaceProfileScreenState();
}

class _PlaceProfileScreenState extends State<PlaceProfileScreen> {
  bool _saved = false;

  PlaceModel get _place =>
      MockData.places.firstWhere((p) => p.id == widget.placeId,
          orElse: () => MockData.places.first);

  @override
  Widget build(BuildContext context) {
    final place = _place;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(context, place),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, place),
                const SizedBox(height: AppSizes.s4),
                _buildQuickInfo(context, place),
                _buildActions(context, place),
                _buildGallery(place),
                _buildReviewsSection(context),
                const SizedBox(height: AppSizes.s48),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/review/new/${place.id}'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
        label: const Text(
          'Write a review',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      )
          .animate(delay: const Duration(milliseconds: 400))
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            curve: AppAnimations.overshoot,
            duration: AppAnimations.normal,
          )
          .fadeIn(duration: AppAnimations.fast),
    );
  }

  Widget _buildHeroAppBar(BuildContext context, PlaceModel place) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: _CircleButton(
        icon: Icons.arrow_back,
        onTap: () => context.pop(),
      ),
      actions: [
        _CircleButton(
          icon: _saved ? Icons.bookmark : Icons.bookmark_outline,
          iconColor: _saved ? AppColors.primary : null,
          onTap: () => setState(() => _saved = !_saved),
        ),
        const SizedBox(width: AppSizes.s8),
        _CircleButton(
          icon: Icons.share_outlined,
          onTap: () {},
        ),
        const SizedBox(width: AppSizes.s8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'place-cover-${place.id}',
          child: Image.network(
            place.coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, _) =>
                Container(color: AppColors.neutral100),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding,
          AppSizes.s20,
          AppSizes.screenHorizontalPadding,
          0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Score
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                )
                    .animate()
                    .fadeIn(duration: AppAnimations.normal)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter,
                    ),
              ),
              const SizedBox(width: AppSizes.s12),
              ScoreBadge(
                score: place.score,
                size: ScoreBadgeSize.large,
                animate: true,
                delay: const Duration(milliseconds: 150),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s8),

          // Category + Wilaya + Reviews count
          Row(
            children: [
              _Chip(label: place.category.label),
              const SizedBox(width: AppSizes.s8),
              WilayaBadge(wilaya: place.wilaya),
              const SizedBox(width: AppSizes.s8),
              Text(
                '${place.reviewCount} reviews',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
              .animate(delay: const Duration(milliseconds: 100))
              .fadeIn(duration: AppAnimations.normal),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s16, AppSizes.screenHorizontalPadding, 0),
      child: Row(
        children: [
          // Open/Closed
          _InfoTile(
            icon: Icons.access_time_rounded,
            iconColor: place.isOpen ? AppColors.success : AppColors.error,
            label: place.isOpen
                ? 'Open${place.openUntil != null ? ' until ${place.openUntil}' : ''}'
                : 'Closed',
            labelColor: place.isOpen ? AppColors.success : AppColors.error,
            animationDelay: 0,
          ),
          const SizedBox(width: AppSizes.s12),
          // Price range
          _InfoTile(
            icon: Icons.attach_money,
            iconColor: AppColors.neutral500,
            label: place.priceRange.label,
            labelColor: AppColors.neutral700,
            animationDelay: 1,
          ),
          if (place.distance != null) ...[
            const SizedBox(width: AppSizes.s12),
            _InfoTile(
              icon: Icons.directions_walk,
              iconColor: AppColors.neutral500,
              label: place.distance!,
              labelColor: AppColors.neutral700,
              animationDelay: 2,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s16, AppSizes.screenHorizontalPadding, 0),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.directions_outlined,
              label: 'Directions',
              onTap: () {},
              animationDelay: 0,
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: _ActionButton(
              icon: Icons.phone_outlined,
              label: 'Call',
              onTap: () {},
              animationDelay: 1,
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: _ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {},
              animationDelay: 2,
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
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.screenHorizontalPadding, AppSizes.s24, 0, AppSizes.s12),
          child: Text('Photos', style: _sectionStyle),
        ),
        SizedBox(
          height: 110,
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
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) =>
                    Container(width: 110, height: 110, color: AppColors.neutral100),
              ),
            )
                .animate(delay: Duration(milliseconds: 60 * i))
                .fadeIn(duration: AppAnimations.normal)
                .scale(
                  begin: const Offset(0.92, 0.92),
                  end: const Offset(1, 1),
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.screenHorizontalPadding, AppSizes.s24, AppSizes.screenHorizontalPadding, AppSizes.s12),
          child: Row(
            children: [
              Text('Reviews', style: _sectionStyle),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
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

  TextStyle get _sectionStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral900,
      );
}

// ---- Small local widgets ----

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

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
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral700,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.animationDelay,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
      ],
    )
        .animate(delay: Duration(milliseconds: 80 + animationDelay * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(begin: 0.1, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.animationDelay,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int animationDelay;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
            color: _pressed ? AppColors.neutral100 : AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 18, color: AppColors.neutral700),
              const SizedBox(height: 3),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral700,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 150 + widget.animationDelay * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.15, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}
