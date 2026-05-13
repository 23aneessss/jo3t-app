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
    return MockData.places
        .where((p) =>
            p.name.toLowerCase().contains(_query.toLowerCase()) ||
            p.category.label.toLowerCase().contains(_query.toLowerCase()) ||
            p.wilaya.toLowerCase().contains(_query.toLowerCase()) ||
            p.neighborhood.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  static const _trending = ['Chez Fatima', 'Café Tanit', 'Blida', 'Cafés', 'Oran'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar row
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.s8, AppSizes.s12, AppSizes.screenHorizontalPadding, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        hintText: 'Search places, wilayas, cuisines…',
                        prefixIcon: const Icon(Icons.search,
                            size: AppSizes.iconInline,
                            color: AppColors.neutral300),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    size: 18, color: AppColors.neutral300),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: AppAnimations.fast),

            const SizedBox(height: AppSizes.s16),

            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: AppAnimations.normal,
                child: _query.isEmpty
                    ? _buildEmptyState()
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

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending searches',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          )
              .animate()
              .fadeIn(duration: AppAnimations.normal),

          const SizedBox(height: AppSizes.s12),

          Wrap(
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
                      horizontal: AppSizes.s12, vertical: AppSizes.s8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up,
                          size: 14, color: AppColors.neutral500),
                      const SizedBox(width: AppSizes.s4),
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
                  .animate(delay: Duration(milliseconds: e.key * 50))
                  .fadeIn(duration: AppAnimations.normal)
                  .slideX(
                    begin: 0.1,
                    end: 0,
                    duration: AppAnimations.normal,
                    curve: AppAnimations.enter,
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      key: const ValueKey('skeleton'),
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
            const Icon(Icons.search_off, size: 48, color: AppColors.neutral300),
            const SizedBox(height: AppSizes.s12),
            Text(
              'No places found for "$_query"',
              style: const TextStyle(
                  fontSize: 15, color: AppColors.neutral500),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppAnimations.normal)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: AppAnimations.normal,
              curve: AppAnimations.enter,
            ),
      );
    }

    return ListView.builder(
      key: const ValueKey('results'),
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final p = _results[i];
        final delay = Duration(milliseconds: i * 50);
        return GestureDetector(
          onTap: () => context.push('/place/${p.id}'),
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding,
                vertical: AppSizes.s4),
            padding: const EdgeInsets.all(AppSizes.s12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: Image.network(
                    p.coverUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) =>
                        Container(width: 56, height: 56, color: AppColors.neutral100),
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600,
                              color: AppColors.neutral900)),
                      const SizedBox(height: 3),
                      Text(
                        '${p.category.label} · ${p.wilaya}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.neutral500),
                      ),
                    ],
                  ),
                ),
                ScoreBadge(score: p.score, size: ScoreBadgeSize.small),
              ],
            ),
          )
              .animate(delay: delay)
              .fadeIn(duration: AppAnimations.normal)
              .slideY(
                begin: 0.08,
                end: 0,
                duration: AppAnimations.normal,
                curve: AppAnimations.enter,
              ),
        );
      },
    );
  }
}
