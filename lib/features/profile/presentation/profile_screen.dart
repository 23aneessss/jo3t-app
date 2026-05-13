import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/review_card.dart';

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
          _buildSliverAppBar(context, innerBoxIsScrolled),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_ReviewsTab(), _SavedTab()],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        expandedHeight: 390,
        pinned: true,
        floating: false,
        forceElevated: innerBoxIsScrolled,
        backgroundColor: AppColors.primary,
        elevation: innerBoxIsScrolled ? 2 : 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: AppSizes.iconInline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: AppSizes.iconInline),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: _ProfileHeader(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: const Border(
                bottom: BorderSide(color: AppColors.neutral100, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.neutral300,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
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

// ---- Profile Header ----

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.5, 1],
          colors: [Color(0xFFFF6B2B), Color(0xFFE8520A), Color(0xFF9E3006)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned.fill(child: CustomPaint(painter: _HeaderPatternPainter())),

          SafeArea(
            child: Column(
              children: [
                // Space for toolbar
                const SizedBox(height: 56),

                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF8C5B), Color(0xFFB33E06)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 1.5),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 13, color: AppColors.primary),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: AppAnimations.medium,
                      curve: AppAnimations.overshoot,
                    ),

                const SizedBox(height: AppSizes.s10),

                // Name
                const Text(
                  'Anes Bouziani',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                )
                    .animate(delay: 80.ms)
                    .fadeIn(duration: AppAnimations.normal)
                    .slideY(begin: 0.2, end: 0, curve: AppAnimations.enter),

                const SizedBox(height: AppSizes.s8),

                // Location + handle row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on,
                              size: 11, color: Colors.white70),
                          const SizedBox(width: 3),
                          const Text(
                            'Blida · Algeria',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .animate(delay: 120.ms)
                    .fadeIn(duration: AppAnimations.normal),

                const SizedBox(height: AppSizes.s16),

                // Achievement badges row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontalPadding),
                  child: Row(
                    children: [
                      _Badge(icon: Icons.star_rounded, label: 'Top Reviewer', delay: 0),
                      const SizedBox(width: AppSizes.s8),
                      _Badge(icon: Icons.explore, label: 'Explorer', delay: 1),
                      const SizedBox(width: AppSizes.s8),
                      _Badge(
                          icon: Icons.local_fire_department,
                          label: 'Foodie',
                          delay: 2),
                    ],
                  ),
                )
                    .animate(delay: 160.ms)
                    .fadeIn(duration: AppAnimations.normal),

                const SizedBox(height: AppSizes.s20),

                // Stats row — frosted white cards
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenHorizontalPadding),
                  child: Row(
                    children: [
                      _StatCard(
                        value: 12,
                        label: 'Reviews',
                        icon: Icons.rate_review_outlined,
                        delay: 0,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      _StatCard(
                        value: 48,
                        label: 'Following',
                        icon: Icons.person_add_outlined,
                        delay: 1,
                      ),
                      const SizedBox(width: AppSizes.s10),
                      _StatCard(
                        value: 23,
                        label: 'Followers',
                        icon: Icons.people_outline,
                        delay: 2,
                      ),
                    ],
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: AppAnimations.normal)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 7; j++) {
        canvas.drawCircle(
          Offset(i * 48.0 - 8, j * 60.0 - 10),
          20,
          paint,
        );
      }
    }
    final paint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      80,
      paint2,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      60,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Badge extends StatelessWidget {
  const _Badge(
      {required this.icon, required this.label, required this.delay});
  final IconData icon;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 160 + delay * 55))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(begin: 0.15, end: 0, curve: AppAnimations.enter);
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.delay,
  });
  final int value;
  final String label;
  final IconData icon;
  final int delay;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: AppAnimations.fast,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(widget.icon, size: 16, color: AppColors.primary),
                const SizedBox(height: 5),
                AnimatedCounter(
                  value: widget.value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neutral900,
                  ),
                  duration: Duration(milliseconds: 900 + widget.delay * 150),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.neutral500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Tabs ----

class _ReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s8)),
          if (MockData.reviews.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(
                icon: Icons.rate_review_outlined,
                title: 'No reviews yet',
                subtitle: 'Discover places and share your experience.',
              ),
            )
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
    final places = MockData.places;
    return Builder(
      builder: (context) => CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s12)),
          if (places.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(
                icon: Icons.bookmark_outline,
                title: 'Nothing saved yet',
                subtitle: 'Tap the bookmark on any place to save it here.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.s10,
                  mainAxisSpacing: AppSizes.s10,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) =>
                      _SavedGridCard(place: places[i], index: i),
                  childCount: places.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }
}

class _SavedGridCard extends StatefulWidget {
  const _SavedGridCard({required this.place, required this.index});
  final PlaceModel place;
  final int index;

  @override
  State<_SavedGridCard> createState() => _SavedGridCardState();
}

class _SavedGridCardState extends State<_SavedGridCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/place/${p.id}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: AppAnimations.fast,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                p.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) =>
                    Container(color: AppColors.neutral100),
              ),
              // Gradient overlay
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1.0],
                    colors: [Colors.transparent, Color(0xA6000000)],
                  ),
                ),
              ),
              // Info
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 11),
                        const SizedBox(width: 3),
                        Text(
                          '${p.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            p.category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Bookmark icon
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark,
                      size: 15, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      )
          .animate(
              delay: Duration(milliseconds: widget.index * 55))
          .fadeIn(duration: AppAnimations.normal)
          .scale(
            begin: const Offset(0.88, 0.88),
            end: const Offset(1, 1),
            curve: AppAnimations.enter,
            duration: AppAnimations.normal,
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
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.s16),
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral700)),
          const SizedBox(height: AppSizes.s8),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.s48),
            child: Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.neutral300,
                    height: 1.5)),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: AppAnimations.enter,
        );
  }
}
