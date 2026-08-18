import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key, required this.initialTab});
  final int initialTab;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _following = <int>{0, 1, 3};

  static const _followers = [
    (name: 'Amine Kaci', wilaya: 'Alger', initial: 'A', color: Color(0xFF4285F4), reviews: 24),
    (name: 'Sara Meziane', wilaya: 'Blida', initial: 'S', color: Color(0xFF34A853), reviews: 18),
    (name: 'Nadia Bensalem', wilaya: 'Constantine', initial: 'N', color: Color(0xFFFF6B2B), reviews: 12),
    (name: 'Riad Aouadi', wilaya: 'Tizi Ouzou', initial: 'R', color: Color(0xFF7B2FBE), reviews: 47),
    (name: 'Karim Hadj', wilaya: 'Oran', initial: 'K', color: Color(0xFFEA4335), reviews: 8),
    (name: 'Lina Saadi', wilaya: 'Béjaïa', initial: 'L', color: Color(0xFFFF9800), reviews: 33),
  ];

  static const _followingList = [
    (name: 'Youcef Hamdi', wilaya: 'Oran', initial: 'Y', color: Color(0xFFEA4335), reviews: 31),
    (name: 'Amine Kaci', wilaya: 'Alger', initial: 'A', color: Color(0xFF4285F4), reviews: 24),
    (name: 'Sara Meziane', wilaya: 'Blida', initial: 'S', color: Color(0xFF34A853), reviews: 18),
    (name: 'Farid Boumediene', wilaya: 'Sétif', initial: 'F', color: Color(0xFF009688), reviews: 15),
    (name: 'Meriem Taleb', wilaya: 'Annaba', initial: 'M', color: Color(0xFFE91E63), reviews: 22),
    (name: 'Riad Aouadi', wilaya: 'Tizi Ouzou', initial: 'R', color: Color(0xFF7B2FBE), reviews: 47),
    (name: 'Omar Chaouch', wilaya: 'Alger', initial: 'O', color: Color(0xFF607D8B), reviews: 11),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: AppSizes.iconInline, color: AppColors.neutral700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Yacine Belkacem',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.neutral100)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.neutral300,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400),
              tabs: [
                Tab(text: '${_followers.length} Followers'),
                Tab(text: '${_followingList.length} Following'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UserList(
            users: _followers,
            following: _following,
            onToggle: _toggleFollow,
          ),
          _UserList(
            users: _followingList,
            following: _following,
            onToggle: _toggleFollow,
          ),
        ],
      ),
    );
  }

  void _toggleFollow(int index) {
    setState(() {
      if (_following.contains(index)) {
        _following.remove(index);
      } else {
        _following.add(index);
        HapticFeedback.lightImpact();
      }
    });
  }
}

class _UserList extends StatelessWidget {
  const _UserList({
    required this.users,
    required this.following,
    required this.onToggle,
  });

  final List<({String name, String wilaya, String initial, Color color, int reviews})> users;
  final Set<int> following;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding, vertical: AppSizes.s12),
      itemCount: users.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSizes.s8),
      itemBuilder: (context, i) {
        final u = users[i];
        final isFollowing = following.contains(i);
        return _UserCard(
          user: u,
          isFollowing: isFollowing,
          index: i,
          onToggle: () => onToggle(i),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.isFollowing,
    required this.index,
    required this.onToggle,
  });

  final ({String name, String wilaya, String initial, Color color, int reviews}) user;
  final bool isFollowing;
  final int index;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s14, vertical: AppSizes.s12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isFollowing
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.neutral100,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: user.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 11, color: AppColors.neutral300),
                    const SizedBox(width: 2),
                    Text(user.wilaya,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.neutral500)),
                    const SizedBox(width: AppSizes.s8),
                    const Icon(Icons.rate_review_outlined,
                        size: 11, color: AppColors.neutral300),
                    const SizedBox(width: 2),
                    Text('${user.reviews}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.neutral500)),
                  ],
                ),
              ],
            ),
          ),
          // Follow button
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              curve: AppAnimations.stateChange,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s14, vertical: AppSizes.s6),
              decoration: BoxDecoration(
                color: isFollowing ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border: Border.all(
                  color: isFollowing
                      ? AppColors.primary
                      : AppColors.neutral200,
                  width: 1.5,
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: AppAnimations.fast,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isFollowing ? Colors.white : AppColors.neutral700,
                ),
                child: Text(isFollowing ? 'Following' : 'Follow'),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(
          begin: 0.04,
          end: 0,
          curve: AppAnimations.enter,
          duration: AppAnimations.normal,
        );
  }
}
