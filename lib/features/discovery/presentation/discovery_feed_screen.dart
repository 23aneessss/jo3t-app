import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
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

  // Mock data for demo
  final _places = [
    (name: 'Chez Fatima', category: 'Restaurant', wilaya: 'Blida', score: 8.5, distance: '1.2 km', image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400'),
    (name: 'Café Tanit', category: 'Café', wilaya: 'Alger', score: 9.1, distance: '0.8 km', image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400'),
    (name: 'Le Pâtissier', category: 'Patisserie', wilaya: 'Oran', score: 7.8, distance: '3.4 km', image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400'),
    (name: 'Snack El Baraka', category: 'Street Food', wilaya: 'Constantine', score: 8.2, distance: '0.4 km', image: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400'),
    (name: 'Fresh Corner', category: 'Juice Bar', wilaya: 'Annaba', score: 9.4, distance: '2.1 km', image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400'),
  ];

  final _featured = [
    (name: 'Chez Fatima', category: 'Restaurant', score: 8.5, image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600'),
    (name: 'Café Tanit', category: 'Café', score: 9.1, image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=600'),
    (name: 'Le Pâtissier', category: 'Patisserie', score: 7.8, image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600'),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
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
            style: TextStyle(
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
          onPressed: () {},
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
          separatorBuilder: (_, _i) => const SizedBox(width: AppSizes.s8),
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              itemCount: _featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.s12),
              itemBuilder: (context, i) {
                final p = _featured[i];
                return PlaceCardVertical(
                  name: p.name,
                  category: p.category,
                  score: p.score,
                  imageUrl: p.image,
                  onTap: () {},
                  animationIndex: i,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbySection() {
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
          if (_loading) {
            return const PlaceCardSkeleton();
          }
          if (dataIndex >= _places.length) return const SizedBox(height: AppSizes.s48);
          final p = _places[dataIndex];
          return PlaceCardHorizontal(
            name: p.name,
            category: p.category,
            wilaya: p.wilaya,
            score: p.score,
            imageUrl: p.image,
            distance: p.distance,
            onTap: () {},
            animationIndex: dataIndex,
          );
        },
        childCount: _loading ? 5 : _places.length + 2,
      ),
    );
  }
}
