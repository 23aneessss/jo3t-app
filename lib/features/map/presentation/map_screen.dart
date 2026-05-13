import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/place_model.dart';
import '../../../shared/widgets/score_badge.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  PlaceModel? _selected;
  int _filterIndex = 0;
  late final AnimationController _pulseController;

  static const _filters = [
    (label: 'All', icon: Icons.grid_view_rounded),
    (label: 'Restaurant', icon: Icons.restaurant),
    (label: 'Café', icon: Icons.coffee),
    (label: 'Street Food', icon: Icons.lunch_dining),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Map background (warm illustrated style)
          _MapBackground(),

          // Mock place pins
          ..._buildPins(context),

          // Top search bar + category chips
          _TopSearchBar(
            filters: _filters,
            selectedIndex: _filterIndex,
            onFilterSelect: (i) => setState(() => _filterIndex = i),
          ),

          // Bottom selected place card
          if (_selected != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _PlaceBottomSheet(
                place: _selected!,
                onClose: () => setState(() => _selected = null),
              ),
            ),

          // Pins count badge (when nothing selected)
          if (_selected == null)
            Positioned(
              bottom: AppSizes.s24,
              left: 0,
              right: 0,
              child: Center(
                child: _PinsCountBadge(
                  count: MockData.places.length,
                  filter: _filters[_filterIndex].label,
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: AppAnimations.normal)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter,
                    ),
              ),
            ),

          // Location FAB
          Positioned(
            right: AppSizes.screenHorizontalPadding,
            bottom: _selected != null ? 190 : 90,
            child: _LocationFAB()
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  delay: 400.ms,
                  curve: AppAnimations.overshoot,
                  duration: AppAnimations.normal,
                ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPins(BuildContext context) {
    final positions = [
      (left: 0.18, top: 0.36, placeIndex: 0),
      (left: 0.55, top: 0.28, placeIndex: 1),
      (left: 0.70, top: 0.52, placeIndex: 2),
      (left: 0.30, top: 0.60, placeIndex: 3),
      (left: 0.50, top: 0.65, placeIndex: 4),
    ];

    return positions.asMap().entries.map((entry) {
      final pos = entry.value;
      final place = MockData.places[pos.placeIndex];
      final isSelected = _selected?.id == place.id;

      return Positioned(
        left: MediaQuery.of(context).size.width * pos.left,
        top: MediaQuery.of(context).size.height * pos.top,
        child: _MapPin(
          place: place,
          isSelected: isSelected,
          pulseController: _pulseController,
          delay: entry.key * 120,
          onTap: () => setState(
              () => _selected = isSelected ? null : place),
        ),
      );
    }).toList();
  }
}

class _MapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: Container(),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base background — warm light gray
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF5F0EB),
    );

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final blockPaint = Paint()..color = const Color(0xFFEDE8E3);

    // Draw city blocks
    final blocks = [
      Rect.fromLTWH(20, 80, 140, 90),
      Rect.fromLTWH(180, 60, 100, 80),
      Rect.fromLTWH(300, 80, 80, 100),
      Rect.fromLTWH(20, 200, 100, 120),
      Rect.fromLTWH(140, 180, 120, 100),
      Rect.fromLTWH(290, 200, 100, 90),
      Rect.fromLTWH(20, 350, 140, 80),
      Rect.fromLTWH(200, 330, 110, 100),
      Rect.fromLTWH(330, 340, 60, 90),
      Rect.fromLTWH(60, 460, 120, 80),
      Rect.fromLTWH(210, 450, 100, 80),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(6)),
        blockPaint,
      );
    }

    // Main roads (horizontal)
    canvas.drawLine(
        Offset(0, size.height * 0.22), Offset(size.width, size.height * 0.22), roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.48), Offset(size.width, size.height * 0.48), roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.72), Offset(size.width, size.height * 0.72), roadPaint);

    // Main roads (vertical)
    canvas.drawLine(
        Offset(size.width * 0.25, 0), Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.55, 0), Offset(size.width * 0.55, size.height), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.82, 0), Offset(size.width * 0.82, size.height), roadPaint);

    // Minor roads
    canvas.drawLine(
        Offset(0, size.height * 0.35), Offset(size.width * 0.55, size.height * 0.35), minorRoadPaint);
    canvas.drawLine(
        Offset(size.width * 0.4, size.height * 0.22), Offset(size.width * 0.4, size.height * 0.72), minorRoadPaint);
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.place,
    required this.isSelected,
    required this.pulseController,
    required this.delay,
    required this.onTap,
  });

  final PlaceModel place;
  final bool isSelected;
  final AnimationController pulseController;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.25 : 1.0,
        duration: AppAnimations.fast,
        curve: AppAnimations.overshoot,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, _) {
                  final pulse = pulseController.value;
                  return Container(
                    width: 44 + pulse * 16,
                    height: 44 + pulse * 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15 - pulse * 0.12),
                    ),
                  );
                },
              ),
            Container(
              padding: isSelected
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                  : const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(isSelected ? 20 : 50),
                boxShadow: [
                  BoxShadow(
                    color: (isSelected ? AppColors.primary : Colors.black)
                        .withValues(alpha: isSelected ? 0.35 : 0.12),
                    blurRadius: isSelected ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Icon(
                      _categoryIcon(place.category),
                      color: AppColors.primary,
                      size: 16,
                    ),
            ),
            // Pin triangle
            CustomPaint(
              size: const Size(12, 6),
              painter: _PinTipPainter(
                  color: isSelected ? AppColors.primary : Colors.white),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          curve: AppAnimations.overshoot,
          duration: AppAnimations.normal,
        )
        .fadeIn(duration: AppAnimations.fast);
  }

  IconData _categoryIcon(PlaceCategory cat) => switch (cat) {
        PlaceCategory.restaurant => Icons.restaurant,
        PlaceCategory.cafe => Icons.coffee,
        PlaceCategory.patisserie => Icons.cake,
        PlaceCategory.streetFood => Icons.lunch_dining,
        PlaceCategory.juiceBar => Icons.local_drink,
        PlaceCategory.sandwich => Icons.lunch_dining,
      };
}

class _PinTipPainter extends CustomPainter {
  const _PinTipPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PinTipPainter old) => old.color != color;
}

class _TopSearchBar extends StatelessWidget {
  const _TopSearchBar({
    required this.filters,
    required this.selectedIndex,
    required this.onFilterSelect,
  });
  final List<({String label, IconData icon})> filters;
  final int selectedIndex;
  final ValueChanged<int> onFilterSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding, AppSizes.s12,
                  AppSizes.screenHorizontalPadding, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.97),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: AppSizes.s16),
                    const Icon(Icons.search, color: AppColors.neutral300, size: 20),
                    const SizedBox(width: AppSizes.s8),
                    const Expanded(
                      child: Text(
                        'Search on map…',
                        style: TextStyle(
                          color: AppColors.neutral300,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.neutral100,
                    ),
                    const SizedBox(width: AppSizes.s12),
                    const Icon(Icons.tune_outlined,
                        size: 18, color: AppColors.neutral500),
                    const SizedBox(width: AppSizes.s16),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(begin: -0.3, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter),
            ),

            const SizedBox(height: AppSizes.s10),

            // Category chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding),
                itemCount: filters.length,
                separatorBuilder: (context, i) =>
                    const SizedBox(width: AppSizes.s8),
                itemBuilder: (context, i) {
                  final f = filters[i];
                  final active = i == selectedIndex;
                  return GestureDetector(
                    onTap: () => onFilterSelect(i),
                    child: AnimatedContainer(
                      duration: AppAnimations.fast,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s12, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white.withValues(alpha: 0.95),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(f.icon,
                              size: 13,
                              color: active ? Colors.white : AppColors.neutral700),
                          const SizedBox(width: AppSizes.s4),
                          Text(
                            f.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : AppColors.neutral700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(delay: Duration(milliseconds: 100 + i * 40))
                      .fadeIn(duration: AppAnimations.normal)
                      .slideX(begin: 0.1, end: 0, curve: AppAnimations.enter);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.my_location,
          color: AppColors.primary, size: 22),
    );
  }
}

class _SetupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(Icons.map_outlined,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSizes.s12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maps SDK required',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Add your Google Maps API key to enable the full map view.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.neutral500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PinsCountBadge extends StatelessWidget {
  const _PinsCountBadge({required this.count, required this.filter});
  final int count;
  final String filter;

  @override
  Widget build(BuildContext context) {
    final label = filter == 'All' ? '$count places on map' : '$count ${filter.toLowerCase()}s found';
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16, vertical: AppSizes.s8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.s8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceBottomSheet extends StatelessWidget {
  const _PlaceBottomSheet({required this.place, required this.onClose});
  final PlaceModel place;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.screenHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.network(
                place.coverUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) =>
                    Container(width: 64, height: 64, color: AppColors.neutral100),
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(place.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral900)),
                  const SizedBox(height: 3),
                  Text(
                    '${place.category.label} · ${place.wilaya}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.neutral500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ScoreBadge(score: place.score, size: ScoreBadgeSize.small),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        place.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: place.isOpen ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: AppColors.neutral500),
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                GestureDetector(
                  onTap: () => context.push('/place/${place.id}'),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward,
                        size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppAnimations.fast)
        .slideY(begin: 0.3, end: 0, duration: AppAnimations.normal, curve: AppAnimations.enter);
  }
}
