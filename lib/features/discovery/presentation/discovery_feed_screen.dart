import 'package:cached_network_image/cached_network_image.dart';
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
  int _activeTab = 0;

  static final _mockActivities = [
    _Activity(
      type: 'review',
      user: 'Amine K.',
      userId: 'amine',
      userWilaya: 'Blida',
      initial: 'A',
      place: MockData.places[0],
      score: 9.0,
      timeAgo: '2h ago',
      reviewText: 'Best couscous in Blida! The lamb was perfectly cooked and the atmosphere is always warm.',
    ),
    _Activity(
      type: 'new_place',
      user: 'Mohamed A.',
      userId: 'mohamed',
      userWilaya: 'Oran',
      initial: 'M',
      place: MockData.places[2],
      timeAgo: '5h ago',
    ),
    _Activity(
      type: 'review',
      user: 'Nadia T.',
      userId: 'nadia',
      userWilaya: 'Médéa',
      initial: 'N',
      place: MockData.places[4],
      score: 9.5,
      timeAgo: '1d ago',
      reviewText: 'These fresh juices are absolutely life-changing. The mango-ginger combo is a must-try!',
    ),
    _Activity(
      type: 'follow',
      user: 'Sara M.',
      userId: 'sara',
      userWilaya: 'Alger',
      initial: 'S',
      followedUser: 'Yacine B.',
      timeAgo: '1d ago',
    ),
    _Activity(
      type: 'save',
      user: 'Karim L.',
      userId: 'karim',
      userWilaya: 'Tizi Ouzou',
      initial: 'K',
      place: MockData.places[1],
      timeAgo: '2d ago',
    ),
    _Activity(
      type: 'review',
      user: 'Yasmine B.',
      userId: 'nadia',
      userWilaya: 'Constantine',
      initial: 'Y',
      place: MockData.places[3],
      score: 8.2,
      timeAgo: '3d ago',
      reviewText: 'Great street food right in the heart of Constantine. Quick service and generous portions.',
    ),
  ];

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
          _buildTabSwitcher(),
          if (_activeTab == 0) _buildCategoryFilter(),
          if (_activeTab == 0) _buildDailyPick(context),
          if (_activeTab == 0) _buildWilayaExplore(context),
          if (_activeTab == 0) _buildFeaturedSection(),
          if (_activeTab == 0) _buildTopRatedSection(context),
          if (_activeTab == 0) _buildEventsSection(context),
          if (_activeTab == 0) _buildNearbySection(),
          if (_activeTab == 1) _buildFollowingFeed(),
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
                  child: CachedNetworkImage(
                    imageUrl: pick.coverUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
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
                AppSizes.screenHorizontalPadding, AppSizes.s24, AppSizes.screenHorizontalPadding, AppSizes.s4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                ),
                GestureDetector(
                  onTap: () => context.push('/leaderboard'),
                  child: const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
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

  static const _wilayaCards = [
    (name: 'Alger', count: 1247, c1: Color(0xFFFF6B35), c2: Color(0xFFFF9562)),
    (name: 'Blida', count: 198, c1: Color(0xFF2ECC71), c2: Color(0xFF27AE60)),
    (name: 'Oran', count: 634, c1: Color(0xFF3498DB), c2: Color(0xFF2980B9)),
    (name: 'Constantine', count: 421, c1: Color(0xFF9B59B6), c2: Color(0xFF8E44AD)),
    (name: 'Annaba', count: 287, c1: Color(0xFF1ABC9C), c2: Color(0xFF16A085)),
    (name: 'Tizi Ouzou', count: 156, c1: Color(0xFFF1C40F), c2: Color(0xFFF39C12)),
  ];

  Widget _buildWilayaExplore(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding, AppSizes.s20,
                AppSizes.screenHorizontalPadding, AppSizes.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore by wilaya',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: () => context.push('/leaderboard'),
                  child: const Text(
                    'Rankings',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 220.ms, duration: AppAnimations.normal)
                .slideX(begin: -0.05, end: 0, curve: AppAnimations.enter),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              itemCount: _wilayaCards.length,
              separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s10),
              itemBuilder: (context, i) {
                final card = _wilayaCards[i];
                final isSelected = _selectedWilaya == card.name;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedWilaya = isSelected ? null : card.name;
                  }),
                  child: AnimatedContainer(
                    duration: AppAnimations.fast,
                    curve: AppAnimations.stateChange,
                    width: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [card.c1, card.c2]
                            : [card.c1.withValues(alpha: 0.75), card.c2.withValues(alpha: 0.75)],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: isSelected
                          ? Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2)
                          : null,
                      boxShadow: isSelected
                          ? [BoxShadow(
                              color: card.c1.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.s12, AppSizes.s12, AppSizes.s12, AppSizes.s10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            card.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${card.count >= 1000 ? "${(card.count / 1000).toStringAsFixed(1)}k" : card.count} places',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate(delay: Duration(milliseconds: 180 + i * 40))
                    .fadeIn(duration: AppAnimations.normal)
                    .scale(
                      begin: const Offset(0.88, 0.88),
                      end: const Offset(1, 1),
                      curve: AppAnimations.overshoot,
                      duration: AppAnimations.normal,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s12,
          AppSizes.screenHorizontalPadding, 0,
        ),
        child: Container(
          height: 38,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Row(
            children: [
              _TabPill(
                label: 'For You',
                selected: _activeTab == 0,
                onTap: () => setState(() => _activeTab = 0),
              ),
              _TabPill(
                label: 'Following',
                selected: _activeTab == 1,
                onTap: () => setState(() => _activeTab = 1),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal),
    );
  }

  static const _mockEvents = [
    (
      placeIndex: 0,
      title: 'Ramadan Special Night',
      date: 'Fri, 7:00 PM',
      attendees: 42,
      color: Color(0xFFFF6B35),
    ),
    (
      placeIndex: 1,
      title: 'Coffee Tasting Session',
      date: 'Sat, 10:00 AM',
      attendees: 18,
      color: Color(0xFF3498DB),
    ),
    (
      placeIndex: 4,
      title: 'Fresh Juice Workshop',
      date: 'Sun, 3:00 PM',
      attendees: 24,
      color: Color(0xFF2ECC71),
    ),
  ];

  Widget _buildEventsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding, AppSizes.s24,
                AppSizes.screenHorizontalPadding, AppSizes.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF6B35), Color(0xFFFF9562)],
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    ),
                    const SizedBox(width: AppSizes.s10),
                    Text(
                      'Events near you',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Text(
                    'This week',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 280.ms, duration: AppAnimations.normal)
                .slideX(begin: -0.05, end: 0, curve: AppAnimations.enter),
          ),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              itemCount: _mockEvents.length,
              separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s12),
              itemBuilder: (context, i) {
                final event = _mockEvents[i];
                final place = MockData.places[event.placeIndex];
                return GestureDetector(
                  onTap: () => context.push('/event/${place.id}_$i', extra: {
                    'title': event.title,
                    'placeName': place.name,
                    'placeId': place.id,
                    'date': event.date,
                    'imageUrl': place.coverUrl,
                    'attendees': event.attendees,
                    'colorValue': event.color.value,
                  }),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image header
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppSizes.radiusLg)),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: place.coverUrl,
                                width: 200,
                                height: 100,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 200,
                                  height: 100,
                                  color: AppColors.neutral100,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.s8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: event.color,
                                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.event_rounded,
                                          size: 10, color: Colors.white),
                                      const SizedBox(width: 3),
                                      Text(
                                        event.date,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Info
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSizes.s10, AppSizes.s8, AppSizes.s10, AppSizes.s8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.neutral900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                place.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.neutral500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.people_outline,
                                      size: 11, color: AppColors.neutral300),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${event.attendees} attending',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.neutral500,
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
                    .animate(delay: Duration(milliseconds: 240 + i * 60))
                    .fadeIn(duration: AppAnimations.normal)
                    .slideX(begin: 0.06, end: 0, curve: AppAnimations.enter, duration: AppAnimations.normal);
              },
            ),
          ),
          const SizedBox(height: AppSizes.s8),
        ],
      ),
    );
  }

  Widget _buildFollowingFeed() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenHorizontalPadding, AppSizes.s16,
                AppSizes.screenHorizontalPadding, AppSizes.s12,
              ),
              child: const Text(
                'Recent from people you follow',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.neutral500,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(duration: AppAnimations.normal),
            );
          }
          final dataIndex = i - 1;
          if (dataIndex >= _mockActivities.length) {
            return const SizedBox(height: AppSizes.s48);
          }
          return _ActivityCard(
            activity: _mockActivities[dataIndex],
            index: dataIndex,
            onPlaceTap: (place) => context.push('/place/${place.id}'),
            onUserTap: (userId) => context.push('/user/$userId'),
          );
        },
        childCount: _mockActivities.length + 2,
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

// ---- Top Ranked Row ----

class _TopRankedRow extends StatefulWidget {
  const _TopRankedRow({
    required this.rank,
    required this.place,
    required this.index,
    required this.onTap,
  });
  final int rank;
  final PlaceModel place;
  final int index;
  final VoidCallback onTap;

  @override
  State<_TopRankedRow> createState() => _TopRankedRowState();
}

class _TopRankedRowState extends State<_TopRankedRow> {
  bool _pressed = false;

  static const _rankColors = [Color(0xFFFFB300), Color(0xFF9E9E9E), Color(0xFFBF7340)];

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    final rankColor = _rankColors[widget.index];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: AppAnimations.micro,
        child: Container(
          margin: const EdgeInsets.fromLTRB(
              AppSizes.screenHorizontalPadding, 0,
              AppSizes.screenHorizontalPadding, AppSizes.s8),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s14, vertical: AppSizes.s12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#${widget.rank}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: rankColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: CachedNetworkImage(
                  imageUrl: p.coverUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Container(width: 52, height: 52, color: AppColors.neutral100),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${p.category.label} · ${p.wilaya}',
                      style: const TextStyle(
                        fontSize: 11,
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
                          '${p.score}/10',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral700,
                          ),
                        ),
                        const SizedBox(width: AppSizes.s8),
                        Text(
                          '${p.reviewCount} reviews',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.neutral300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(Icons.chevron_right,
                  size: 18, color: AppColors.neutral300),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 200 + widget.index * 70))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(begin: 0.04, end: 0, curve: AppAnimations.enter, duration: AppAnimations.normal);
  }
}

// ---- Tab Pill ----

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          curve: AppAnimations.stateChange,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.neutral900 : AppColors.neutral500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Activity data model ----

class _Activity {
  const _Activity({
    required this.type,
    required this.user,
    required this.userId,
    required this.userWilaya,
    required this.initial,
    this.place,
    this.score,
    this.followedUser,
    required this.timeAgo,
    this.reviewText,
  });
  final String type; // 'review' | 'follow' | 'new_place' | 'save'
  final String user;
  final String userId;
  final String userWilaya;
  final String initial;
  final PlaceModel? place;
  final double? score;
  final String? followedUser;
  final String timeAgo;
  final String? reviewText;
}

// ---- Activity Card ----

class _ActivityCard extends StatefulWidget {
  const _ActivityCard({
    required this.activity,
    required this.index,
    required this.onPlaceTap,
    required this.onUserTap,
  });
  final _Activity activity;
  final int index;
  final ValueChanged<PlaceModel> onPlaceTap;
  final ValueChanged<String> onUserTap;

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _pressed = false;
  bool _following = false;

  bool get _hasPlace => widget.activity.place != null;
  bool get _isFollow => widget.activity.type == 'follow';

  IconData get _typeIcon => switch (widget.activity.type) {
        'review' => Icons.star_rounded,
        'follow' => Icons.person_add_outlined,
        'new_place' => Icons.add_location_alt_outlined,
        'save' => Icons.bookmark_outline,
        _ => Icons.circle,
      };

  Color get _typeColor => switch (widget.activity.type) {
        'review' => Colors.amber,
        'follow' => AppColors.primary,
        'new_place' => AppColors.success,
        'save' => AppColors.primary,
        _ => AppColors.neutral300,
      };

  String get _actionText {
    final a = widget.activity;
    return switch (a.type) {
      'review' => 'rated ${a.place!.name}',
      'follow' => 'started following ${a.followedUser!}',
      'new_place' => 'added ${a.place!.name} to JO3T',
      'save' => 'saved ${a.place!.name}',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.activity;
    return GestureDetector(
      onTapDown: (_hasPlace && !_isFollow) ? (_) => setState(() => _pressed = true) : null,
      onTapUp: (_hasPlace && !_isFollow)
          ? (_) {
              setState(() => _pressed = false);
              widget.onPlaceTap(a.place!);
            }
          : null,
      onTapCancel: (_hasPlace && !_isFollow) ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: AppAnimations.micro,
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            AppSizes.screenHorizontalPadding, 0,
            AppSizes.screenHorizontalPadding, AppSizes.s10,
          ),
          padding: const EdgeInsets.all(AppSizes.s14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with type badge (tappable → user profile)
              GestureDetector(
                onTap: () => widget.onUserTap(a.userId),
                child: Stack(
                  children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.7),
                          AppColors.primaryDark,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        a.initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _typeColor,
                        shape: BoxShape.circle,
                        border: const Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: Center(
                        child: Icon(_typeIcon, size: 9, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              ),
              const SizedBox(width: AppSizes.s12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral700,
                        ),
                        children: [
                          TextSpan(
                            text: a.user,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral900,
                            ),
                          ),
                          TextSpan(text: ' $_actionText'),
                          if (a.score != null)
                            TextSpan(
                              text: ' · ${a.score}/10',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.scoreColor(a.score!),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (a.reviewText != null) ...[
                      const SizedBox(height: AppSizes.s6),
                      Text(
                        a.reviewText!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.neutral500,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSizes.s8),
                    if (_isFollow)
                      GestureDetector(
                        onTap: () => setState(() => _following = !_following),
                        child: AnimatedContainer(
                          duration: AppAnimations.fast,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _following ? AppColors.neutral100 : AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            border: _following
                                ? Border.all(color: AppColors.neutral200)
                                : null,
                          ),
                          child: Text(
                            _following ? 'Following' : 'Follow back',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _following ? AppColors.neutral700 : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      a.timeAgo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.neutral300,
                      ),
                    ),
                  ],
                ),
              ),
              // Place thumbnail (for non-follow activities)
              if (_hasPlace && !_isFollow) ...[
                const SizedBox(width: AppSizes.s10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: CachedNetworkImage(
                    imageUrl: a.place!.coverUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: AppColors.neutral100,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.index * 60))
        .fadeIn(duration: AppAnimations.normal)
        .slideY(
          begin: 0.06,
          end: 0,
          curve: AppAnimations.enter,
          duration: AppAnimations.normal,
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
