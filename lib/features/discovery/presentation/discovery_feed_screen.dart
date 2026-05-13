import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/category_chip.dart';
import '../../../shared/widgets/place_card.dart';
import '../../../shared/widgets/skeleton_loader.dart';

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> {
  int _selectedCategory = 0;
  bool _loading = true;

  final _categories = [
    (label: 'All', icon: Icons.grid_view_rounded),
    (label: 'Restaurant', icon: Icons.restaurant),
    (label: 'Café', icon: Icons.coffee),
    (label: 'Patisserie', icon: Icons.cake),
    (label: 'Street Food', icon: Icons.lunch_dining),
    (label: 'Juice Bar', icon: Icons.local_drink),
  ];

  List<PlaceModel> get _filteredPlaces {
    if (_selectedCategory == 0) return MockData.places;
    final label = _categories[_selectedCategory].label;
    return MockData.places
        .where((p) => p.category.label == label)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildCategoryFilter(),
          _buildDailyPick(context),
          _buildFeaturedSection(),
          _buildNearbySection(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      title: Row(
        children: [
          Text(
            'جعت',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Text(
            '· Blida',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.neutral500),
          ),
        ],
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal)
          .slideY(begin: -0.2, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: AppSizes.iconNav),
          onPressed: () => context.go('/search'),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 100), duration: AppAnimations.normal),
        const SizedBox(width: AppSizes.s8),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenHorizontalPadding, vertical: AppSizes.s8),
          itemCount: _categories.length,
          separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s8),
          itemBuilder: (context, i) {
            final cat = _categories[i];
            return CategoryChip(
              label: cat.label,
              icon: cat.icon,
              selected: _selectedCategory == i,
              onTap: () => setState(() => _selectedCategory = i),
              animationDelay: AppAnimations.staggerDelay * i,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDailyPick(BuildContext context) {
    final pick = MockData.places[1]; // Café Tanit — highest rated
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => context.push('/place/${pick.id}'),
        child: Container(
          margin: const EdgeInsets.fromLTRB(
              AppSizes.screenHorizontalPadding, AppSizes.s16,
              AppSizes.screenHorizontalPadding, 0),
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'place-cover-${pick.id}',
                  child: Image.network(
                    pick.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(color: AppColors.neutral100),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSizes.s12,
                  left: AppSizes.s16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome,
                            color: Colors.white, size: 11),
                        SizedBox(width: 4),
                        Text(
                          "JO3T's Pick Today",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppSizes.s16,
                  left: AppSizes.s16,
                  right: AppSizes.s16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pick.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 8)
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${pick.score}/10 · ${pick.reviewCount} reviews · ${pick.wilaya}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
        )
            .animate()
            .fadeIn(
                delay: const Duration(milliseconds: 150),
                duration: AppAnimations.normal)
            .slideY(
              begin: 0.06,
              end: 0,
              duration: AppAnimations.normal,
              curve: AppAnimations.enter,
            ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding, AppSizes.s20, 0, AppSizes.s12),
            child: Text(
              'Featured near you',
              style: Theme.of(context).textTheme.headlineMedium,
            )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 200), duration: AppAnimations.normal)
                .slideX(begin: -0.05, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
          ),
          SizedBox(
            height: 200,
            child: _loading
                ? _buildFeaturedSkeleton()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.screenHorizontalPadding),
                    itemCount: MockData.places.take(3).length,
                    separatorBuilder: (context, i) =>
                        const SizedBox(width: AppSizes.s12),
                    itemBuilder: (context, i) {
                      final p = MockData.places[i];
                      return PlaceCardVertical(
                        placeId: p.id,
                        name: p.name,
                        category: p.category.label,
                        score: p.score,
                        imageUrl: p.coverUrl,
                        distance: p.distance,
                        onTap: () => context.push('/place/${p.id}'),
                        animationIndex: i,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSkeleton() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenHorizontalPadding),
      itemCount: 3,
      separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s12),
      itemBuilder: (context, i) => SkeletonLoader(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbySection() {
    final places = _filteredPlaces;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s24,
                  0,
                  AppSizes.s12),
              child: Text(
                'Near you',
                style: Theme.of(context).textTheme.headlineMedium,
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 300), duration: AppAnimations.normal)
                  .slideX(begin: -0.05, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
            );
          }
          final dataIndex = i - 1;
          if (_loading) return const PlaceCardSkeleton();
          if (dataIndex >= places.length) {
            return const SizedBox(height: AppSizes.s48);
          }
          final p = places[dataIndex];
          return PlaceCardHorizontal(
            placeId: p.id,
            name: p.name,
            category: p.category.label,
            wilaya: p.wilaya,
            score: p.score,
            imageUrl: p.coverUrl,
            distance: p.distance,
            onTap: () => context.push('/place/${p.id}'),
            animationIndex: dataIndex,
          );
        },
        childCount: _loading ? 6 : places.length + 2,
      ),
    );
  }
}
