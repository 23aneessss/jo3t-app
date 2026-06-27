import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_animations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/config/app_env.dart';
import '../../place/domain/entities/place_entity.dart';
import '../../place/presentation/providers/place_providers.dart';
import '../../../shared/widgets/score_badge.dart';

// Algiers center as default
const _kAlgiersLatLng = LatLng(36.7372, 3.0863);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  PlaceEntity? _selected;
  PlaceCategoryEntity? _filterCategory;
  late final AnimationController _pulseController;

  static const _filters = [
    (label: 'All', category: null as PlaceCategoryEntity?),
    (label: 'Restaurants', category: PlaceCategoryEntity.restaurant),
    (label: 'Cafés', category: PlaceCategoryEntity.cafe),
    (label: 'Street Food', category: PlaceCategoryEntity.streetFood),
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
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers(List<PlaceEntity> places) {
    final filtered = _filterCategory == null
        ? places
        : places.where((p) => p.category == _filterCategory).toList();

    return filtered.asMap().entries.map((entry) {
      final place = entry.value;
      final latLng = _latLngFor(place, entry.key);
      return Marker(
        markerId: MarkerId(place.id),
        position: latLng,
        onTap: () => setState(() => _selected = place),
        infoWindow: InfoWindow.noText,
      );
    }).toSet();
  }

  // Fallback coordinates for places without geo data (scatter around Algiers)
  static const _fallbackOffsets = [
    LatLng(36.7372, 3.0863),
    LatLng(36.7500, 3.0600),
    LatLng(36.7200, 3.1100),
    LatLng(36.7600, 3.0400),
    LatLng(36.7100, 3.0900),
    LatLng(36.7450, 3.1300),
    LatLng(36.7650, 3.0700),
  ];

  LatLng _latLngFor(PlaceEntity place, int index) {
    if (place.latitude != null && place.longitude != null) {
      return LatLng(place.latitude!, place.longitude!);
    }
    return _fallbackOffsets[index % _fallbackOffsets.length];
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(feedPlacesProvider(null));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Real Google Map (requires Maps API key via --dart-define=MAPS_API_KEY=...)
          if (AppEnv.mapsApiKey.isNotEmpty)
            placesAsync.when(
              data: (places) => GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _kAlgiersLatLng,
                  zoom: 12,
                ),
                onMapCreated: (c) => _mapController = c,
                markers: _buildMarkers(places),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onTap: (_) => setState(() => _selected = null),
              ),
              loading: () => _MapBackground(),
              error: (_, _) => _MapBackground(),
            )
          else
            // Illustrated fallback when no Maps key configured
            _MapBackground(),

          // Mock pins overlay (used in both modes for visual feedback)
          if (AppEnv.mapsApiKey.isEmpty)
            placesAsync.maybeWhen(
              data: (places) => _MockPinsOverlay(
                places: _filterCategory == null
                    ? places
                    : places
                        .where((p) => p.category == _filterCategory)
                        .toList(),
                selected: _selected,
                pulseController: _pulseController,
                onTap: (p) =>
                    setState(() => _selected = _selected?.id == p.id ? null : p),
              ),
              orElse: () => const SizedBox.shrink(),
            ),

          // Top search bar + category chips
          _TopBar(
            filters: _filters,
            selectedCategory: _filterCategory,
            onFilterSelect: (cat) => setState(() {
              _filterCategory = cat;
              _selected = null;
            }),
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

          // Pins count badge
          if (_selected == null)
            placesAsync.maybeWhen(
              data: (places) {
                final count = _filterCategory == null
                    ? places.length
                    : places
                        .where((p) => p.category == _filterCategory)
                        .length;
                return Positioned(
                  bottom: AppSizes.s24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _PinsCountBadge(count: count)
                        .animate()
                        .fadeIn(
                            delay: 600.ms, duration: AppAnimations.normal)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: AppAnimations.normal,
                          curve: AppAnimations.enter,
                        ),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),

          // Location FAB
          Positioned(
            right: AppSizes.screenHorizontalPadding,
            bottom: _selected != null ? 196 : 90,
            child: _LocationFAB(
              onTap: () => _mapController?.animateCamera(
                CameraUpdate.newLatLng(_kAlgiersLatLng),
              ),
            )
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
}

// ── Illustrated map background (fallback) ──────────────────────────────────

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

    for (final block in [
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
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(6)),
        blockPaint,
      );
    }

    canvas.drawLine(Offset(0, size.height * 0.22),
        Offset(size.width, size.height * 0.22), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.48),
        Offset(size.width, size.height * 0.48), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.72),
        Offset(size.width, size.height * 0.72), roadPaint);
    canvas.drawLine(Offset(size.width * 0.25, 0),
        Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.55, 0),
        Offset(size.width * 0.55, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.82, 0),
        Offset(size.width * 0.82, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.35),
        Offset(size.width * 0.55, size.height * 0.35), minorRoadPaint);
    canvas.drawLine(Offset(size.width * 0.4, size.height * 0.22),
        Offset(size.width * 0.4, size.height * 0.72), minorRoadPaint);
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}

// ── Mock pins overlay (used when no Maps key) ──────────────────────────────

class _MockPinsOverlay extends StatelessWidget {
  const _MockPinsOverlay({
    required this.places,
    required this.selected,
    required this.pulseController,
    required this.onTap,
  });

  final List<PlaceEntity> places;
  final PlaceEntity? selected;
  final AnimationController pulseController;
  final ValueChanged<PlaceEntity> onTap;

  static const _positions = [
    (left: 0.18, top: 0.36),
    (left: 0.55, top: 0.28),
    (left: 0.70, top: 0.52),
    (left: 0.30, top: 0.60),
    (left: 0.50, top: 0.65),
    (left: 0.12, top: 0.55),
    (left: 0.78, top: 0.35),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: places.take(_positions.length).toList().asMap().entries.map(
        (entry) {
          final pos = _positions[entry.key];
          final place = entry.value;
          return Positioned(
            left: size.width * pos.left,
            top: size.height * pos.top,
            child: _MapPin(
              place: place,
              isSelected: selected?.id == place.id,
              pulseController: pulseController,
              delay: entry.key * 120,
              onTap: () => onTap(place),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.place,
    required this.isSelected,
    required this.pulseController,
    required this.delay,
    required this.onTap,
  });

  final PlaceEntity place;
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
                      color: AppColors.primary
                          .withValues(alpha: 0.15 - pulse * 0.12),
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
                borderRadius:
                    BorderRadius.circular(isSelected ? 20 : 50),
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

  IconData _categoryIcon(PlaceCategoryEntity cat) => switch (cat) {
        PlaceCategoryEntity.restaurant => Icons.restaurant,
        PlaceCategoryEntity.cafe => Icons.coffee,
        PlaceCategoryEntity.patisserie => Icons.cake,
        PlaceCategoryEntity.streetFood => Icons.lunch_dining,
        PlaceCategoryEntity.juiceBar => Icons.local_drink,
        PlaceCategoryEntity.sandwich => Icons.lunch_dining,
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

// ── Top bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.filters,
    required this.selectedCategory,
    required this.onFilterSelect,
  });

  final List<({String label, PlaceCategoryEntity? category})> filters;
  final PlaceCategoryEntity? selectedCategory;
  final ValueChanged<PlaceCategoryEntity?> onFilterSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenHorizontalPadding,
                  AppSizes.s12,
                  AppSizes.screenHorizontalPadding,
                  0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.97),
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusFull),
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
                    const Icon(Icons.search,
                        color: AppColors.neutral300, size: 20),
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
                        width: 1, height: 24, color: AppColors.neutral100),
                    const SizedBox(width: AppSizes.s12),
                    const Icon(Icons.tune_outlined,
                        size: 18, color: AppColors.neutral500),
                    const SizedBox(width: AppSizes.s16),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: AppAnimations.normal)
                  .slideY(
                      begin: -0.3,
                      end: 0,
                      duration: AppAnimations.normal,
                      curve: AppAnimations.enter),
            ),
            const SizedBox(height: AppSizes.s10),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenHorizontalPadding),
                itemCount: filters.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSizes.s8),
                itemBuilder: (context, i) {
                  final f = filters[i];
                  final active = selectedCategory == f.category;
                  return GestureDetector(
                    onTap: () => onFilterSelect(f.category),
                    child: AnimatedContainer(
                      duration: AppAnimations.fast,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.s12, vertical: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.95),
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
                      child: Text(
                        f.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Colors.white
                              : AppColors.neutral700,
                        ),
                      ),
                    ),
                  )
                      .animate(
                          delay: Duration(milliseconds: 100 + i * 40))
                      .fadeIn(duration: AppAnimations.normal)
                      .slideX(
                          begin: 0.1,
                          end: 0,
                          curve: AppAnimations.enter);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── FAB & badges ───────────────────────────────────────────────────────────

class _LocationFAB extends StatelessWidget {
  const _LocationFAB({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

class _PinsCountBadge extends StatelessWidget {
  const _PinsCountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
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
            '$count places on map',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet preview ────────────────────────────────────────────────────

class _PlaceBottomSheet extends StatelessWidget {
  const _PlaceBottomSheet({required this.place, required this.onClose});
  final PlaceEntity place;
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
              child: place.coverPhotoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: place.coverPhotoUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _PlaceholderImage(),
                    )
                  : _PlaceholderImage(),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${place.category.label} · ${place.wilayaId}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.neutral500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ScoreBadge(
                          score: place.jo3tScore,
                          size: ScoreBadgeSize.small),
                      const SizedBox(width: AppSizes.s8),
                      if (place.isOpen != null)
                        Text(
                          place.isOpen! ? 'Open' : 'Closed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: place.isOpen!
                                ? AppColors.success
                                : AppColors.error,
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
                    decoration: const BoxDecoration(
                      color: AppColors.neutral100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: AppColors.neutral500),
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                GestureDetector(
                  onTap: () => context.push('/place/${place.id}'),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
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
        .slideY(
            begin: 0.3,
            end: 0,
            duration: AppAnimations.normal,
            curve: AppAnimations.enter);
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: AppColors.neutral100,
      child: const Icon(Icons.place,
          color: AppColors.neutral300, size: 28),
    );
  }
}
