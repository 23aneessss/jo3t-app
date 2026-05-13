import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    (path: '/feed', icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover'),
    (path: '/search', icon: Icons.search, activeIcon: Icons.search, label: 'Search'),
    (path: '/map', icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map'),
    (path: '/saved', icon: Icons.bookmark_outline, activeIcon: Icons.bookmark, label: 'Saved'),
    (path: '/profile', icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _tabs.indexWhere((t) => location.startsWith(t.path));

    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _AddFAB()
          .animate()
          .scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            delay: const Duration(milliseconds: 300),
            curve: AppAnimations.overshoot,
            duration: AppAnimations.normal,
          ),
      bottomNavigationBar: _BottomBar(
        tabs: _tabs,
        currentIndex: currentIndex,
        onTap: (path) => context.go(path),
      ),
    );
  }
}

class _AddFAB extends StatefulWidget {
  @override
  State<_AddFAB> createState() => _AddFABState();
}

class _AddFABState extends State<_AddFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: AppAnimations.fast);
    _rotateAnim = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.stateChange),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.mediumImpact();
        context.push('/add-place');
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _rotateAnim,
        builder: (context, child) => Transform.rotate(
          angle: _rotateAnim.value * 2 * 3.14159,
          child: child,
        ),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  final List<({String path, IconData icon, IconData activeIcon, String label})> tabs;
  final int currentIndex;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 64,
      padding: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      notchMargin: 8,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(),
        CircleBorder(),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.neutral100,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left 2 tabs
            ...tabs.sublist(0, 2).asMap().entries.map((e) => Expanded(
                  child: _NavItem(
                    icon: e.value.icon,
                    activeIcon: e.value.activeIcon,
                    label: e.value.label,
                    selected: e.key == currentIndex,
                    onTap: () => onTap(e.value.path),
                  ),
                )),
            // Center spacer for FAB
            const Expanded(child: SizedBox()),
            // Right 2 tabs
            ...tabs.sublist(3).asMap().entries.map((e) => Expanded(
                  child: _NavItem(
                    icon: e.value.icon,
                    activeIcon: e.value.activeIcon,
                    label: e.value.label,
                    selected: (e.key + 3) == currentIndex,
                    onTap: () => onTap(e.value.path),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppAnimations.fast);
    _scaleAnim = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.overshoot),
    );
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.selected && !old.selected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: Icon(
                widget.selected ? widget.activeIcon : widget.icon,
                key: ValueKey(widget.selected),
                color: widget.selected ? AppColors.primary : AppColors.neutral300,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: AppAnimations.fast,
            style: TextStyle(
              fontSize: 10,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
              color: widget.selected ? AppColors.primary : AppColors.neutral300,
            ),
            child: Text(widget.label),
          ),
        ],
      ),
    );
  }
}
