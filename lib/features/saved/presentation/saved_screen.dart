import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/score_badge.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _activeCollection = 0;

  final _collections = [
    (label: 'All saved', icon: Icons.bookmark, count: 5),
    (label: 'Want to try', icon: Icons.bookmark_add_outlined, count: 3),
    (label: 'Favorites', icon: Icons.favorite_outline, count: 2),
    (label: 'Visited', icon: Icons.check_circle_outline, count: 4),
  ];

  void _showCreateCollection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateCollectionSheet(
        onCreated: (label, icon) {
          setState(() {
            _collections.add((label: label, icon: icon, count: 0));
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"$label" collection created'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
          );
        },
      ),
    );
  }

  List<PlaceModel> get _places {
    return MockData.places;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildCollections(),
          _buildGrid(context),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.s48)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor: const Color(0xFFF8F8F8),
      elevation: 0,
      title: const Text(
        'Saved',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.neutral900,
        ),
      )
          .animate()
          .fadeIn(duration: AppAnimations.normal),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, size: AppSizes.iconNav,
              color: AppColors.primary),
          onPressed: _showCreateCollection,
        )
            .animate(delay: 60.ms)
            .fadeIn(duration: AppAnimations.normal),
      ],
    );
  }

  Widget _buildCollections() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.s8),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenHorizontalPadding),
              itemCount: _collections.length,
              separatorBuilder: (context, i) =>
                  const SizedBox(width: AppSizes.s8),
              itemBuilder: (context, i) {
                final col = _collections[i];
                final active = i == _activeCollection;
                return GestureDetector(
                  onTap: () => setState(() => _activeCollection = i),
                  child: AnimatedContainer(
                    duration: AppAnimations.fast,
                    curve: AppAnimations.stateChange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s14, vertical: AppSizes.s8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : AppColors.neutral200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          col.icon,
                          size: 14,
                          color: active ? Colors.white : AppColors.neutral500,
                        ),
                        const SizedBox(width: AppSizes.s6),
                        Text(
                          col.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: active
                                ? Colors.white
                                : AppColors.neutral700,
                          ),
                        ),
                        const SizedBox(width: AppSizes.s6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white.withValues(alpha: 0.25)
                                : AppColors.neutral100,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: Text(
                            '${col.count}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: active
                                  ? Colors.white
                                  : AppColors.neutral500,
                            ),
                          ),
                        ),
                      ],
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
          const SizedBox(height: AppSizes.s16),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenHorizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_places.length} places',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutral500,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.sort, size: 14, color: AppColors.neutral500),
                    const SizedBox(width: 4),
                    const Text(
                      'Recently saved',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ],
            )
                .animate(delay: 120.ms)
                .fadeIn(duration: AppAnimations.normal),
          ),
          const SizedBox(height: AppSizes.s12),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final places = _places;
    if (places.isEmpty) {
      return SliverFillRemaining(
        child: _EmptyState(),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenHorizontalPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSizes.s10,
          mainAxisSpacing: AppSizes.s10,
          childAspectRatio: 0.76,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _SavedCard(place: places[i], index: i),
          childCount: places.length,
        ),
      ),
    );
  }
}

class _SavedCard extends StatefulWidget {
  const _SavedCard({required this.place, required this.index});
  final PlaceModel place;
  final int index;

  @override
  State<_SavedCard> createState() => _SavedCardState();
}

class _SavedCardState extends State<_SavedCard> {
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusLg),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'place-cover-${p.id}-saved',
                        child: Image.network(
                          p.coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) =>
                              Container(color: AppColors.neutral100),
                        ),
                      ),
                      // Top row: open status + bookmark
                      Positioned(
                        top: 8,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: p.isOpen
                                    ? AppColors.success
                                        .withValues(alpha: 0.9)
                                    : Colors.black54,
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusFull),
                              ),
                              child: Text(
                                p.isOpen ? 'Open' : 'Closed',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.bookmark,
                                  size: 14, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Info
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.s10, AppSizes.s8, AppSizes.s10, AppSizes.s10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        ScoreBadge(
                            score: p.score,
                            size: ScoreBadgeSize.small,
                            animate: false),
                        const SizedBox(width: AppSizes.s6),
                        Expanded(
                          child: Text(
                            p.category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 10, color: AppColors.neutral300),
                        const SizedBox(width: 2),
                        Text(
                          p.wilaya,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.neutral500,
                          ),
                        ),
                        if (p.distance != null) ...[
                          const SizedBox(width: AppSizes.s6),
                          Text(
                            p.distance!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.neutral300,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: widget.index * 55))
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_outline,
                size: 36, color: AppColors.primary),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 1.06, duration: 1800.ms)
              .then()
              .scaleXY(begin: 1.06, end: 1.0, duration: 1800.ms),
          const SizedBox(height: AppSizes.s20),
          const Text(
            'Nothing saved yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral700,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.s48),
            child: Text(
              'Tap the bookmark on any place to save it for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.neutral300,
                height: 1.5,
              ),
            ),
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
}

// ---- Create Collection Bottom Sheet ----

class _CreateCollectionSheet extends StatefulWidget {
  const _CreateCollectionSheet({required this.onCreated});
  final void Function(String label, IconData icon) onCreated;

  @override
  State<_CreateCollectionSheet> createState() => _CreateCollectionSheetState();
}

class _CreateCollectionSheetState extends State<_CreateCollectionSheet> {
  final _controller = TextEditingController();
  int _selectedIcon = 0;

  static const _iconOptions = [
    (icon: Icons.bookmark_outline, label: 'Bookmark'),
    (icon: Icons.favorite_outline, label: 'Favorite'),
    (icon: Icons.restaurant_outlined, label: 'Food'),
    (icon: Icons.coffee_outlined, label: 'Café'),
    (icon: Icons.star_outline_rounded, label: 'Star'),
    (icon: Icons.map_outlined, label: 'Map'),
    (icon: Icons.celebration_outlined, label: 'Event'),
    (icon: Icons.travel_explore, label: 'Explore'),
  ];

  bool get _canCreate => _controller.text.trim().length >= 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenHorizontalPadding,
        AppSizes.s16,
        AppSizes.screenHorizontalPadding,
        AppSizes.s16 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
          const Text(
            'New collection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          // Name field
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'Collection name',
              counterStyle: const TextStyle(fontSize: 11, color: AppColors.neutral300),
              prefixIcon: Icon(
                _iconOptions[_selectedIcon].icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s20),
          // Icon picker
          const Text(
            'Choose an icon',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          ),
          const SizedBox(height: AppSizes.s12),
          Wrap(
            spacing: AppSizes.s10,
            runSpacing: AppSizes.s10,
            children: _iconOptions.asMap().entries.map((entry) {
              final selected = _selectedIcon == entry.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = entry.key),
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryLight : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.neutral200,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Icon(
                    entry.value.icon,
                    size: 22,
                    color: selected ? AppColors.primary : AppColors.neutral500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.s24),
          // Create button
          SizedBox(
            width: double.infinity,
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              height: 52,
              decoration: BoxDecoration(
                color: _canCreate ? AppColors.primary : AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: GestureDetector(
                onTap: _canCreate
                    ? () => widget.onCreated(
                          _controller.text.trim(),
                          _iconOptions[_selectedIcon].icon,
                        )
                    : null,
                child: Center(
                  child: Text(
                    'Create collection',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _canCreate ? Colors.white : AppColors.neutral300,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s8),
        ],
      ),
    );
  }
}
