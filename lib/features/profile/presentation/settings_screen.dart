import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifReviews = true;
  bool _notifFollows = true;
  bool _notifNewPlaces = false;
  bool _notifWeeklyDigest = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        backgroundColor: AppColors.neutral50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: AppSizes.iconInline, color: AppColors.neutral700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenHorizontalPadding),
        children: [
          const SizedBox(height: AppSizes.s8),

          // Profile card
          _buildProfileCard(context),

          const SizedBox(height: AppSizes.s24),

          _SectionHeader(label: 'Notifications', icon: Icons.notifications_outlined),
          const SizedBox(height: AppSizes.s10),
          _SettingsCard(
            children: [
              _ToggleRow(
                label: 'Review interactions',
                subtitle: 'Likes and comments on your reviews',
                value: _notifReviews,
                onChanged: (v) => setState(() => _notifReviews = v),
                index: 0,
              ),
              _Divider(),
              _ToggleRow(
                label: 'New followers',
                subtitle: 'When someone follows you',
                value: _notifFollows,
                onChanged: (v) => setState(() => _notifFollows = v),
                index: 1,
              ),
              _Divider(),
              _ToggleRow(
                label: 'New places near you',
                subtitle: 'When a new place opens in your wilaya',
                value: _notifNewPlaces,
                onChanged: (v) => setState(() => _notifNewPlaces = v),
                index: 2,
              ),
              _Divider(),
              _ToggleRow(
                label: 'Weekly digest',
                subtitle: 'Top picks every Sunday',
                value: _notifWeeklyDigest,
                onChanged: (v) => setState(() => _notifWeeklyDigest = v),
                index: 3,
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s24),

          _SectionHeader(label: 'Preferences', icon: Icons.tune_outlined),
          const SizedBox(height: AppSizes.s10),
          _SettingsCard(
            children: [
              _SelectRow(
                label: 'Language',
                value: _language,
                options: const ['English', 'Français', 'العربية'],
                onSelect: (v) => setState(() => _language = v),
                index: 0,
              ),
              _Divider(),
              _NavRow(
                label: 'Food preferences',
                subtitle: 'Update your cuisine interests',
                icon: Icons.restaurant_menu_outlined,
                onTap: () => context.push('/food-preferences'),
                index: 1,
              ),
              _Divider(),
              _NavRow(
                label: 'Location (Wilaya)',
                subtitle: 'Blida',
                icon: Icons.location_on_outlined,
                onTap: () => context.push('/wilaya-select'),
                index: 2,
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s24),

          _SectionHeader(label: 'About', icon: Icons.info_outline),
          const SizedBox(height: AppSizes.s10),
          _SettingsCard(
            children: [
              _InfoRow(label: 'Version', value: '1.0.0 Phase 1 Beta', index: 0),
              _Divider(),
              _NavRow(
                label: 'Terms of service',
                icon: Icons.description_outlined,
                onTap: () {},
                index: 1,
              ),
              _Divider(),
              _NavRow(
                label: 'Privacy policy',
                icon: Icons.privacy_tip_outlined,
                onTap: () {},
                index: 2,
              ),
              _Divider(),
              _NavRow(
                label: 'Send feedback',
                icon: Icons.feedback_outlined,
                onTap: () {},
                index: 3,
              ),
            ],
          ),

          const SizedBox(height: AppSizes.s24),

          // Sign out
          GestureDetector(
            onTap: () => _showSignOut(context),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout, size: 18, color: AppColors.error),
                  const SizedBox(width: AppSizes.s8),
                  const Text(
                    'Sign out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate(delay: 400.ms)
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s48),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yacine Belkacem',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'anaasbouziani@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/edit-profile'),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12, vertical: AppSizes.s6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.08, end: 0, curve: AppAnimations.enter);
  }

  void _showSignOut(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
        ),
        padding: const EdgeInsets.fromLTRB(
            AppSizes.s24, AppSizes.s20, AppSizes.s24, AppSizes.s48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
            const SizedBox(height: AppSizes.s24),
            const Icon(Icons.logout, size: 40, color: AppColors.error),
            const SizedBox(height: AppSizes.s16),
            const Text(
              'Sign out?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: AppSizes.s8),
            const Text(
              'You can sign back in at any time.',
              style: TextStyle(fontSize: 14, color: AppColors.neutral500),
            ),
            const SizedBox(height: AppSizes.s24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.go('/onboarding'),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Shared components ----

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.neutral500),
        const SizedBox(width: AppSizes.s6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral500,
            letterSpacing: 0.8,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal);
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(children: children),
    )
        .animate()
        .fadeIn(duration: AppAnimations.normal)
        .slideY(begin: 0.05, end: 0, curve: AppAnimations.enter);
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1, thickness: 1, indent: AppSizes.s16, endIndent: 0,
        color: AppColors.neutral100);
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.index,
  });
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16, vertical: AppSizes.s12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral900)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.neutral500)),
                ],
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 + index * 40))
        .fadeIn(duration: AppAnimations.normal);
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.onTap,
    required this.index,
  });
  final String label;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16, vertical: AppSizes.s14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.neutral500),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral900)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.neutral500)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.neutral300),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 80 + index * 40))
        .fadeIn(duration: AppAnimations.normal);
  }
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onSelect,
    required this.index,
  });
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelect;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _OptionSheet(
          title: label,
          options: options,
          selected: value,
          onSelect: onSelect,
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16, vertical: AppSizes.s14),
        child: Row(
          children: [
            const Icon(Icons.language_outlined,
                size: 18, color: AppColors.neutral500),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral900)),
            ),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.neutral500)),
            const SizedBox(width: AppSizes.s4),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.neutral300),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 80 + index * 40))
        .fadeIn(duration: AppAnimations.normal);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.label, required this.value, required this.index});
  final String label;
  final String value;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16, vertical: AppSizes.s14),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral900)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.neutral500)),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 + index * 40))
        .fadeIn(duration: AppAnimations.normal);
  }
}

class _OptionSheet extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSizes.s24, AppSizes.s20, AppSizes.s24, AppSizes.s48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900)),
          const SizedBox(height: AppSizes.s16),
          ...options.map((opt) {
            final active = opt == selected;
            return GestureDetector(
              onTap: () {
                onSelect(opt);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.s16, vertical: AppSizes.s14),
                margin: const EdgeInsets.only(bottom: AppSizes.s8),
                decoration: BoxDecoration(
                  color: active ? AppColors.primaryLight : AppColors.neutral50,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.neutral200,
                  ),
                ),
                child: Row(
                  children: [
                    Text(opt,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: active
                              ? AppColors.primary
                              : AppColors.neutral900,
                        )),
                    const Spacer(),
                    if (active)
                      const Icon(Icons.check_circle,
                          size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
