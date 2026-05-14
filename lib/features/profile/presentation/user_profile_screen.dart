import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/score_badge.dart';

typedef _UserData = ({
  String name,
  String wilaya,
  String initial,
  int reviews,
  int followers,
  int following,
  int mutual,
  List<({PlaceModel place, double score, String timeAgo, String text})> reviewed,
});

final _mockUsers = <String, _UserData>{
  'amine': (
    name: 'Amine Kader',
    wilaya: 'Blida',
    initial: 'A',
    reviews: 47,
    followers: 134,
    following: 89,
    mutual: 2,
    reviewed: [
      (
        place: MockData.places[0],
        score: 9.0,
        timeAgo: '2d ago',
        text: 'Best couscous in Blida! The lamb was perfectly cooked and the atmosphere is always warm.',
      ),
      (
        place: MockData.places[1],
        score: 8.5,
        timeAgo: '2w ago',
        text: 'Great coffee and a wonderful view. Definitely a spot to spend the afternoon.',
      ),
    ],
  ),
  'sara': (
    name: 'Sara Meziane',
    wilaya: 'Alger',
    initial: 'S',
    reviews: 83,
    followers: 287,
    following: 145,
    mutual: 5,
    reviewed: [
      (
        place: MockData.places[1],
        score: 9.2,
        timeAgo: '5d ago',
        text: 'Best café in Alger by far. The coffee is exceptional and the staff always remembers your name.',
      ),
      (
        place: MockData.places[4],
        score: 8.8,
        timeAgo: '3w ago',
        text: 'Incredibly fresh juices, the prices are very reasonable too.',
      ),
    ],
  ),
  'nadia': (
    name: 'Nadia Talbi',
    wilaya: 'Médéa',
    initial: 'N',
    reviews: 29,
    followers: 67,
    following: 34,
    mutual: 1,
    reviewed: [
      (
        place: MockData.places[4],
        score: 9.5,
        timeAgo: '1d ago',
        text: 'Life-changing juices. The mango-ginger combo is a must-try!',
      ),
    ],
  ),
  'karim': (
    name: 'Karim Lounès',
    wilaya: 'Tizi Ouzou',
    initial: 'K',
    reviews: 61,
    followers: 198,
    following: 112,
    mutual: 3,
    reviewed: [
      (
        place: MockData.places[3],
        score: 8.2,
        timeAgo: '1w ago',
        text: 'Best street food at a great price. Always fresh and quick.',
      ),
      (
        place: MockData.places[2],
        score: 7.5,
        timeAgo: '1m ago',
        text: 'Good patisserie but a bit pricey. The sfenj is excellent though.',
      ),
    ],
  ),
  'mohamed': (
    name: 'Mohamed Ayad',
    wilaya: 'Oran',
    initial: 'M',
    reviews: 112,
    followers: 456,
    following: 203,
    mutual: 7,
    reviewed: [
      (
        place: MockData.places[0],
        score: 8.0,
        timeAgo: '3d ago',
        text: 'Solid traditional restaurant. The bourek is outstanding.',
      ),
      (
        place: MockData.places[3],
        score: 9.0,
        timeAgo: '2w ago',
        text: 'Late-night street food at its best. Open until 2AM which is perfect.',
      ),
    ],
  ),
};

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _following = false;

  _UserData? get _user => _mockUsers[widget.userId];

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(child: Text('User not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, user),
          _buildStats(user),
          _buildReviewsHeader(),
          _buildReviewsList(context, user),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, _UserData user) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSizes.s32),
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user.initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1, 1),
                      curve: AppAnimations.overshoot,
                      duration: AppAnimations.normal,
                    )
                    .fadeIn(duration: AppAnimations.fast),
                const SizedBox(height: AppSizes.s12),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                )
                    .animate(delay: 60.ms)
                    .fadeIn(duration: AppAnimations.normal),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 12, color: Colors.white70),
                    const SizedBox(width: 3),
                    Text(
                      user.wilaya,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    if (user.mutual > 0) ...[
                      const SizedBox(width: AppSizes.s8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Text(
                          '${user.mutual} mutual',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
                    .animate(delay: 80.ms)
                    .fadeIn(duration: AppAnimations.normal),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.s8),
          child: GestureDetector(
            onTap: () => setState(() => _following = !_following),
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s16, vertical: AppSizes.s8),
              decoration: BoxDecoration(
                color: _following
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border: _following
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.5))
                    : null,
              ),
              child: Text(
                _following ? 'Following' : 'Follow',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _following ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: AppAnimations.normal),
      ],
    );
  }

  Widget _buildStats(_UserData user) {
    final stats = [
      (label: 'Reviews', value: '${user.reviews}'),
      (label: 'Followers', value: '${user.followers}'),
      (label: 'Following', value: '${user.following}'),
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s16,
          AppSizes.screenHorizontalPadding, 0,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.neutral100),
        ),
        child: Row(
          children: stats.asMap().entries.map((entry) {
            final stat = entry.value;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    stat.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      )
          .animate(delay: 120.ms)
          .fadeIn(duration: AppAnimations.normal)
          .slideY(begin: 0.06, end: 0, curve: AppAnimations.enter, duration: AppAnimations.normal),
    );
  }

  Widget _buildReviewsHeader() {
    return SliverToBoxAdapter(
      child: const Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding, AppSizes.s20,
          0, AppSizes.s10,
        ),
        child: Text(
          'Recent reviews',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
      ).animate(delay: 160.ms).fadeIn(duration: AppAnimations.normal),
    );
  }

  Widget _buildReviewsList(BuildContext context, _UserData user) {
    if (user.reviewed.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'No reviews yet',
            style: TextStyle(color: AppColors.neutral500),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final r = user.reviewed[i];
          return GestureDetector(
            onTap: () => context.push('/place/${r.place.id}'),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: Image.network(
                      r.place.coverUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.neutral100,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.place.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.neutral900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSizes.s8),
                            ScoreBadge(
                              score: r.score,
                              size: ScoreBadgeSize.small,
                              animate: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${r.place.category.label} · ${r.place.wilaya}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.neutral500,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s6),
                        Text(
                          r.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.neutral700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.timeAgo,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.neutral300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate(delay: Duration(milliseconds: 180 + i * 60))
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                begin: 0.06,
                end: 0,
                curve: AppAnimations.enter,
                duration: AppAnimations.normal,
              );
        },
        childCount: user.reviewed.length,
      ),
    );
  }
}
