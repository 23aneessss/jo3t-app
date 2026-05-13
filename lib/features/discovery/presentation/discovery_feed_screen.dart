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
  String? _selectedWilaya;
  bool _loading = true;

  final _categories = [
    (label: 'All', icon: Icons.grid_view_rounded),
    (label: 'Restaurant', icon: Icons.restaurant),
    (label: 'Café', icon: Icons.coffee),
    (label: 'Patisserie', icon: Icons.cake),
    (label: 'Street Food', icon: Icons.lunch_dining),
    (label: 'Juice Bar', icon: Icons.local_drink),
  ];

  static const _wilayas = [
    'Alger', 'Blida', 'Oran', 'Constantine', 'Annaba',
    'Tizi Ouzou', 'Sétif', 'Boumerdès', 'Béjaïa', 'Batna',
  ];

  List<PlaceModel> get _filteredPlaces {
    var places = MockData.places;
    if (_selectedCategory != 0) {
      final label = _categories[_selectedCategory].label;
      places = places.where((p) => p.category.label == label).toList();
    }
    if (_selectedWilaya != null) {
      places = places.where((p) => p.wilaya == _selectedWilaya).toList();
    }
    return places;
  }

  void _showWilayaFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WilayaFilterSheet(
        wilayas: _wilayas,
        selected: _selectedWilaya,
        onSelect: (w) {
          setState(() => _selectedWilaya = w);
          Navigator.pop(context);
        },
        onClear: () {
          setState(() => _selectedWilaya = null);
          Navigator.pop(context);
        },
      ),
    );
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
          _buildTopRatedSection(context),
          _buildNearbySection(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      title: GestureDetector(
        onTap: _showWilayaFilter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: Text(
                _selectedWilaya != null ? '· $_selectedWilaya' : '· Algeria',
                key: ValueKey(_selectedWilaya),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.neutral500),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: _selectedWilaya != null
                  ? AppColors.primary
                  : AppColors.neutral300,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal)
          .slideY(begin: -0.2, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
      actions: [
        // Notifications bell
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  size: AppSizes.iconNav),
              onPressed: () => context.push('/notifications'),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 80), duration: AppAnimations.normal),
        IconButton(
          icon: const Icon(Icons.search, size: AppSizes.iconNav),
          onPressed: () => context.go('/search'),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 120), duration: AppAnimations.normal),
        const SizedBox(width: AppSizes.s4),
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

  Widget _buildTopRatedSection(BuildContext context) {
    final topPlaces = [...MockData.places]
      ..sort((a, b) => b.score.compareTo(a.score));
    final top3 = topPlaces.take(3).toList();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding, AppSizes.s24, 0, AppSizes.s4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                ),
                const SizedBox(width: AppSizes.s10),
                Text(
                  'Top rated this week',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 250.ms, duration: AppAnimations.normal)
                .slideX(begin: -0.05, end: 0, curve: AppAnimations.enter),
          ),
          const SizedBox(height: AppSizes.s12),
          ...top3.asMap().entries.map(
                (e) => _TopRankedRow(
                  rank: e.key + 1,
                  place: e.value,
                  index: e.key,
                  onTap: () => context.push('/place/${e.value.id}'),
                ),
              ),
          const SizedBox(height: AppSizes.s8),
        ],
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

// ---- Wilaya Filter Bottom Sheet ----

class _WilayaFilterSheet extends StatelessWidget {
  const _WilayaFilterSheet({
    required this.wilayas,
    required this.selected,
    required this.onSelect,
    required this.onClear,
  });
  final List<String> wilayas;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding,
          AppSizes.s16,
          AppSizes.screenHorizontalPadding,
          AppSizes.s48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by wilaya',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral900,
                ),
              ),
              if (selected != null)
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s12, vertical: AppSizes.s4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Text(
                      'Clear filter',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.s16),
          // "Near me" option
          GestureDetector(
            onTap: () => onSelect('Blida'),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.s14),
              margin: const EdgeInsets.only(bottom: AppSizes.s16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.near_me, size: 18, color: AppColors.primary),
                  SizedBox(width: AppSizes.s10),
                  Text(
                    'Near me · Blida',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            spacing: AppSizes.s8,
            runSpacing: AppSizes.s8,
            children: wilayas.map((w) {
              final active = selected == w;
              return GestureDetector(
                onTap: () => onSelect(w),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s16, vertical: AppSizes.s10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: active
                          ? AppColors.primary
                          : AppColors.neutral200,
                    ),
                  ),
                  child: Text(
                    w,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? Colors.white : AppColors.neutral700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
