import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../place/domain/entities/place_entity.dart';
import '../../../place/presentation/providers/place_providers.dart';
import '../../domain/entities/discovery_filters.dart';

// Active filters state
class DiscoveryFiltersNotifier extends Notifier<DiscoveryFilters> {
  @override
  DiscoveryFilters build() => const DiscoveryFilters();

  void setCategory(PlaceCategoryEntity? category) {
    state = state.copyWith(
      category: category,
      clearCategory: category == null,
    );
  }

  void setWilaya(String? wilayaId) {
    state = state.copyWith(
      wilayaId: wilayaId,
      clearWilaya: wilayaId == null,
    );
  }

  void toggleNearMe() {
    state = state.copyWith(nearMe: !state.nearMe);
  }

  void clearAll() {
    state = const DiscoveryFilters();
  }
}

final discoveryFiltersProvider =
    NotifierProvider<DiscoveryFiltersNotifier, DiscoveryFilters>(
  DiscoveryFiltersNotifier.new,
);

// Filtered feed — reacts to filter changes
final filteredFeedProvider = FutureProvider<List<PlaceEntity>>((ref) async {
  final filters = ref.watch(discoveryFiltersProvider);
  final result = await ref.watch(
    feedPlacesProvider(filters.category).future,
  );
  var places = result;
  if (filters.wilayaId != null) {
    places = places
        .where((p) => p.wilayaId == filters.wilayaId)
        .toList();
  }
  return places;
});

// Feed tab state: 0 = For You, 1 = Following
class FeedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int tab) => state = tab;
}

final feedTabProvider = NotifierProvider<FeedTabNotifier, int>(
  FeedTabNotifier.new,
);
