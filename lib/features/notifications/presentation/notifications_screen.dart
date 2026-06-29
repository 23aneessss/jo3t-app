import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

typedef _Notif = ({
  _NotifType type,
  String avatar,
  IconData? icon,
  Color avatarColor,
  String title,
  String subtitle,
  String time,
  bool unread,
});

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _read = <int>{};
  int _filterTab = 0;

  static const _filterTabs = ['All', 'Reviews', 'Follows', 'Places', 'Weekly'];

  static final _notifications = <_Notif>[
    (
      type: _NotifType.review,
      avatar: 'A',
      icon: null,
      avatarColor: const Color(0xFF4285F4),
      title: 'Amine liked your review',
      subtitle: 'Your review of Café Tanit · 8.5/10',
      time: '2m ago',
      unread: true,
    ),
    (
      type: _NotifType.follow,
      avatar: 'S',
      icon: null,
      avatarColor: const Color(0xFF34A853),
      title: 'Sara Meziane started following you',
      subtitle: 'Food lover · Blida',
      time: '18m ago',
      unread: true,
    ),
    (
      type: _NotifType.place,
      avatar: '',
      icon: Icons.restaurant_outlined,
      avatarColor: AppColors.primaryLight,
      title: 'New place in Blida',
      subtitle: 'Chez Atlas just opened near you',
      time: '1h ago',
      unread: true,
    ),
    (
      type: _NotifType.review,
      avatar: 'Y',
      icon: null,
      avatarColor: const Color(0xFFEA4335),
      title: 'Youcef commented on your review',
      subtitle: '"Totally agree, Chez Fatima is a must"',
      time: '3h ago',
      unread: false,
    ),
    (
      type: _NotifType.weekly,
      avatar: '',
      icon: Icons.insights_outlined,
      avatarColor: const Color(0xFFF5F0FF),
      title: 'Your weekly digest is ready',
      subtitle: '5 new places added in Blida this week',
      time: 'Yesterday',
      unread: false,
    ),
    (
      type: _NotifType.follow,
      avatar: 'N',
      icon: null,
      avatarColor: const Color(0xFFFF6B2B),
      title: 'Nadia Bensalem started following you',
      subtitle: 'Patisserie lover · Constantine',
      time: '2d ago',
      unread: false,
    ),
    (
      type: _NotifType.place,
      avatar: '',
      icon: Icons.star_outline_rounded,
      avatarColor: const Color(0xFFFFFBEE),
      title: 'JO3T\'s Pick of the week',
      subtitle: 'Café Tanit has been selected this week',
      time: '3d ago',
      unread: false,
    ),
  ];

  int get _unreadCount =>
      _notifications.where((n) => n.unread && !_read.contains(_notifications.indexOf(n))).length;

  List<MapEntry<int, _Notif>> get _filteredEntries {
    return _notifications.asMap().entries.where((e) {
      if (_filterTab == 0) return true;
      return switch (_filterTab) {
        1 => e.value.type == _NotifType.review,
        2 => e.value.type == _NotifType.follow,
        3 => e.value.type == _NotifType.place,
        4 => e.value.type == _NotifType.weekly,
        _ => true,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildFilterChips(),
          _buildList(),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          if (_unreadCount > 0) ...[
            const SizedBox(width: AppSizes.s8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8, vertical: AppSizes.s2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal),
      actions: [
        if (_unreadCount > 0)
          TextButton(
            onPressed: () {
              setState(() {
                for (int i = 0; i < _notifications.length; i++) {
                  _read.add(i);
                }
              });
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          )
              .animate(delay: 60.ms)
              .fadeIn(duration: AppAnimations.normal),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontalPadding,
            vertical: AppSizes.s6,
          ),
          itemCount: _filterTabs.length,
          separatorBuilder: (context, i) => const SizedBox(width: AppSizes.s8),
          itemBuilder: (context, i) {
            final selected = _filterTab == i;
            return GestureDetector(
              onTap: () => setState(() => _filterTab = i),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                curve: AppAnimations.stateChange,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s14, vertical: AppSizes.s6),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.neutral200,
                  ),
                ),
                child: Text(
                  _filterTabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? Colors.white : AppColors.neutral700,
                  ),
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: i * 40))
                .fadeIn(duration: AppAnimations.normal)
                .slideX(
                  begin: 0.08,
                  end: 0,
                  curve: AppAnimations.enter,
                  duration: AppAnimations.normal,
                );
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    final entries = _filteredEntries;
    if (entries.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_none_outlined,
                  size: 48, color: AppColors.neutral200),
              const SizedBox(height: AppSizes.s12),
              Text(
                'No ${_filterTabs[_filterTab].toLowerCase()} notifications',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          final entry = entries[i];
          final originalIndex = entry.key;
          final n = entry.value;
          final isRead = _read.contains(originalIndex) || !n.unread;
          return _NotifTile(
            type: n.type,
            avatar: n.avatar,
            avatarIcon: n.icon,
            avatarColor: n.avatarColor,
            title: n.title,
            subtitle: n.subtitle,
            time: n.time,
            read: isRead,
            index: i,
            onTap: () => setState(() => _read.add(originalIndex)),
          );
        },
        childCount: entries.length,
      ),
    );
  }
}

enum _NotifType { review, follow, place, weekly }

class _NotifTile extends StatelessWidget {
  const _NotifTile({
    required this.type,
    required this.avatar,
    required this.avatarIcon,
    required this.avatarColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.read,
    required this.index,
    required this.onTap,
  });

  final _NotifType type;
  final String avatar;
  final IconData? avatarIcon;
  final Color avatarColor;
  final String title;
  final String subtitle;
  final String time;
  final bool read;
  final int index;
  final VoidCallback onTap;

  IconData get _typeIcon => switch (type) {
        _NotifType.review => Icons.rate_review_outlined,
        _NotifType.follow => Icons.person_add_outlined,
        _NotifType.place => Icons.place_outlined,
        _NotifType.weekly => Icons.analytics_outlined,
      };

  Color get _typeColor => switch (type) {
        _NotifType.review => AppColors.primary,
        _NotifType.follow => const Color(0xFF34A853),
        _NotifType.place => const Color(0xFF4285F4),
        _NotifType.weekly => const Color(0xFF7B2FBE),
      };

  @override
  Widget build(BuildContext context) {
    final hasIcon = avatarIcon != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        color: read ? Colors.white : AppColors.primaryLight.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontalPadding,
            vertical: AppSizes.s14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with type badge
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: hasIcon
                        ? Icon(avatarIcon,
                            size: AppSizes.iconInline, color: _typeColor)
                        : Text(
                            avatar,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
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
                      border:
                          Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(_typeIcon, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(width: AppSizes.s12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: read
                                ? FontWeight.w400
                                : FontWeight.w600,
                            color: AppColors.neutral900,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.s8),
                      if (!read)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.neutral300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 45))
        .fadeIn(duration: AppAnimations.normal)
        .slideX(
          begin: 0.04,
          end: 0,
          curve: AppAnimations.enter,
          duration: AppAnimations.normal,
        );
  }
}
