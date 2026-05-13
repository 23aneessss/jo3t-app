import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/review_card.dart';
import '../../../shared/widgets/place_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverHeader(context, innerBoxIsScrolled),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _ReviewsTab(),
            _SavedTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        expandedHeight: 300,
        pinned: true,
        floating: false,
        forceElevated: innerBoxIsScrolled,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                size: AppSizes.iconInline),
            onPressed: () {},
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: _ProfileHeader(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.neutral500,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Reviews'),
                Tab(text: 'Saved'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8520A), Color(0xFFB33E06)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.s32),

            // Avatar
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4), width: 3),
                    gradient: const LinearGradient(
                      colors: [Colors.white24, Colors.white10],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1),
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 13, color: AppColors.primary),
                  ),
                ),
              ],
            )
                .animate()
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1, 1),
                  duration: AppAnimations.medium,
                  curve: AppAnimations.overshoot,
                ),

            const SizedBox(height: AppSizes.s12),

            const Text(
              'Anes Bouziani',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            )
                .animate(delay: const Duration(milliseconds: 100))
                .fadeIn(duration: AppAnimations.normal)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: AppSizes.s4),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 13, color: Colors.white60),
                const SizedBox(width: 3),
                const Text(
                  'Blida, Algeria',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
                .animate(delay: const Duration(milliseconds: 150))
                .fadeIn(duration: AppAnimations.normal),

            const SizedBox(height: AppSizes.s20),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatPill(value: 12, label: 'Reviews', delay: 0),
                _StatDivider(),
                _StatPill(value: 48, label: 'Following', delay: 1),
                _StatDivider(),
                _StatPill(value: 23, label: 'Followers', delay: 2),
              ],
            )
                .animate(delay: const Duration(milliseconds: 200))
                .fadeIn(duration: AppAnimations.normal),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label, required this.delay});
  final int value;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCounter(
          value: value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
          duration: Duration(milliseconds: 1000 + delay * 150),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.s8)),
          if (MockData.reviews.isEmpty)
            SliverFillRemaining(child: _EmptyState(
              icon: Icons.rate_review_outlined,
              title: 'No reviews yet',
              subtitle: 'Discover places and share your experience.',
            ))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => ReviewCard(
                  authorName: MockData.reviews[i].authorName,
                  authorWilaya: MockData.reviews[i].authorWilaya,
                  authorInitial: MockData.reviews[i].authorInitial,
                  score: MockData.reviews[i].score,
                  text: MockData.reviews[i].text,
                  timeAgo: MockData.reviews[i].timeAgo,
                  animationIndex: i,
                ),
                childCount: MockData.reviews.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }
}

class _SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: AppSizes.s8)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = MockData.places[i];
                return PlaceCardHorizontal(
                  placeId: p.id,
                  name: p.name,
                  category: p.category.label,
                  wilaya: p.wilaya,
                  score: p.score,
                  imageUrl: p.coverUrl,
                  distance: p.distance,
                  onTap: () => context.push('/place/${p.id}'),
                  animationIndex: i,
                );
              },
              childCount: MockData.places.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: AppColors.neutral200),
          const SizedBox(height: AppSizes.s16),
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral500)),
          const SizedBox(height: AppSizes.s8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral300,
                  height: 1.5)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
