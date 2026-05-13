import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/score_badge.dart';
import '../../../shared/widgets/skeleton_loader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  bool _searching = false;

  List<PlaceModel> get _results {
    if (_query.trim().isEmpty) return [];
    final q = _query.toLowerCase();
    return MockData.places
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.label.toLowerCase().contains(q) ||
            p.wilaya.toLowerCase().contains(q) ||
            p.neighborhood.toLowerCase().contains(q))
        .toList();
  }

  static const _trending = [
    'Chez Fatima',
    'Café Tanit',
    'Blida',
    'Cafés',
    'Oran',
  ];

  static const _categories = [
    (label: 'Restaurant', emoji: '🍽️', color: Color(0xFFFFF3EE)),
    (label: 'Café', emoji: '☕', color: Color(0xFFEFF6FF)),
    (label: 'Patisserie', emoji: '🍰', color: Color(0xFFFFF5F7)),
    (label: 'Street Food', emoji: '🌮', color: Color(0xFFEFFFF4)),
    (label: 'Juice Bar', emoji: '🥤', color: Color(0xFFFFFBEE)),
    (label: 'Sandwich', emoji: '🥙', color: Color(0xFFF5EEFF)),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _onChanged(String v) async {
    setState(() {
      _query = v;
      _searching = v.isNotEmpty;
    });
    if (v.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted && _query == v) setState(() => _searching = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar header
            _SearchBar(
              controller: _controller,
              focus: _focus,
              query: _query,
              onChanged: _onChanged,
              onClear: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
            // Divider
            const Divider(height: 1, color: AppColors.neutral100),
            // Body
            Expanded(
              child: AnimatedSwitcher(
                duration: AppAnimations.normal,
                switchInCurve: AppAnimations.enter,
                child: _query.isEmpty
                    ? _buildExplore()
                    : _searching
                        ? _buildSkeleton()
                        : _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplore() {
    return SingleChildScrollView(
      key: const ValueKey('explore'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s20),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: const Text(
              'Browse by category',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral900,
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.normal)
                .slideY(
                  begin: -0.1,
                  end: 0,
                  duration: AppAnimations.normal,
                  curve: AppAnimations.enter,
                ),
          ),

          const SizedBox(height: AppSizes.s12),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: AppSizes.s10,
              mainAxisSpacing: AppSizes.s10,
              childAspectRatio: 1.05,
              children: _categories.asMap().entries.map((e) {
                final cat = e.value;
                return _CategoryCard(
                  label: cat.label,
                  emoji: cat.emoji,
                  color: cat.color,
                  index: e.key,
                  onTap: () {
                    _controller.text = cat.label;
                    _onChanged(cat.label);
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSizes.s28),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department,
                      size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: AppSizes.s10),
                const Text(
                  'Trending now',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            )
                .animate(delay: 180.ms)
                .fadeIn(duration: AppAnimations.normal),
          ),

          const SizedBox(height: AppSizes.s12),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: Wrap(
              spacing: AppSizes.s8,
              runSpacing: AppSizes.s8,
              children: _trending.asMap().entries.map((e) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = e.value;
                    _onChanged(e.value);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s14, vertical: AppSizes.s8),
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                      border: Border.all(color: AppColors.neutral200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up,
                            size: 13, color: AppColors.neutral500),
                        const SizedBox(width: AppSizes.s6),
                        Text(
                          e.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(
                        delay: Duration(milliseconds: 220 + e.key * 40))
                    .fadeIn(duration: AppAnimations.normal)
                    .slideX(
                      begin: 0.1,
                      end: 0,
                      curve: AppAnimations.enter,
                      duration: AppAnimations.normal,
                    );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSizes.s48),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      key: const ValueKey('skeleton'),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding,
          vertical: AppSizes.s12),
      itemCount: 4,
      itemBuilder: (context, i) => const PlaceCardSkeleton(),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        key: const ValueKey('no-results'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off,
                  size: 32, color: AppColors.neutral300),
            ),
            const SizedBox(height: AppSizes.s16),
            Text(
              'No results for "$_query"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral700,
              ),
            ),
            const SizedBox(height: AppSizes.s8),
            const Text(
              'Try a different name, city or category',
              style: TextStyle(fontSize: 13, color: AppColors.neutral500),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppAnimations.normal)
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              curve: AppAnimations.enter,
            ),
      );
    }

    return ListView.builder(
      key: const ValueKey('results'),
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding,
          AppSizes.s12,
          AppSizes.screenHorizontalPadding,
          AppSizes.s48),
      itemCount: _results.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s12),
            child: Text(
              '${_results.length} place${_results.length > 1 ? 's' : ''} found',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral500,
              ),
            )
                .animate()
                .fadeIn(duration: AppAnimations.fast),
          );
        }
        final p = _results[i - 1];
        return _ResultCard(place: p, index: i - 1);
      },
    );
  }
}

// ---- Search Bar ----

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.focus,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });
  final TextEditingController controller;
  final FocusNode focus;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() => _focused = widget.focus.hasFocus);

  @override
  void dispose() {
    widget.focus.removeListener(_onFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenHorizontalPadding,
          AppSizes.s12,
          AppSizes.screenHorizontalPadding,
          AppSizes.s12),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focused ? AppColors.primary : AppColors.neutral200,
            width: _focused ? 1.5 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 14,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSizes.s16),
            AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: Icon(
                Icons.search,
                key: ValueKey(_focused),
                size: AppSizes.iconInline,
                color: _focused ? AppColors.primary : AppColors.neutral300,
              ),
            ),
            const SizedBox(width: AppSizes.s10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focus,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral900,
                ),
                decoration: const InputDecoration(
                  hintText: 'Places, cities, cuisines…',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: AppColors.neutral300,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (widget.query.isNotEmpty) ...[
              GestureDetector(
                onTap: widget.onClear,
                child: Container(
                  margin: const EdgeInsets.only(right: AppSizes.s12),
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.neutral200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      size: 13, color: AppColors.neutral700),
                ),
              ),
            ] else
              const SizedBox(width: AppSizes.s16),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.fast)
          .slideY(begin: -0.08, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
    );
  }
}

// ---- Category Card ----

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.label,
    required this.emoji,
    required this.color,
    required this.index,
    required this.onTap,
  });
  final String label;
  final String emoji;
  final Color color;
  final int index;
  final VoidCallback onTap;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: AppAnimations.fast,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral700,
                ),
              ),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: widget.index * 38))
          .fadeIn(duration: AppAnimations.normal)
          .scale(
            begin: const Offset(0.82, 0.82),
            end: const Offset(1, 1),
            curve: AppAnimations.overshoot,
            duration: AppAnimations.normal,
          ),
    );
  }
}

// ---- Result Card ----

class _ResultCard extends StatefulWidget {
  const _ResultCard({required this.place, required this.index});
  final PlaceModel place;
  final int index;

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
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
        scale: _pressed ? 0.97 : 1.0,
        duration: AppAnimations.fast,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.s10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.neutral100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppSizes.radiusLg - 1),
                ),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: Image.network(
                    p.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(color: AppColors.neutral100),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.s12, AppSizes.s10, AppSizes.s12, AppSizes.s10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutral900,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.s8),
                          ScoreBadge(
                              score: p.score, size: ScoreBadgeSize.small),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(
                                  AppSizes.radiusFull),
                            ),
                            child: Text(
                              p.category.label,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.s6),
                          const Icon(Icons.location_on_outlined,
                              size: 11, color: AppColors.neutral300),
                          const SizedBox(width: 2),
                          Text(
                            p.wilaya,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 7,
                            color: p.isOpen
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: AppSizes.s4),
                          Text(
                            p.isOpen
                                ? 'Open · ${p.openUntil}'
                                : 'Closed',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: p.isOpen
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          const Spacer(),
                          if (p.distance.isNotEmpty) ...[
                            const Icon(Icons.near_me_outlined,
                                size: 11, color: AppColors.neutral300),
                            const SizedBox(width: 3),
                            Text(
                              p.distance,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.neutral500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: widget.index * 50))
            .fadeIn(duration: AppAnimations.normal)
            .slideY(
              begin: 0.06,
              end: 0,
              curve: AppAnimations.enter,
              duration: AppAnimations.normal,
            ),
      ),
    );
  }
}
