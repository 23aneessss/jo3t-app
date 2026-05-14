import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_place_repository.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/usecases/get_place_by_id_usecase.dart';
import '../../domain/usecases/get_places_usecase.dart';

// Repository provider
final placeRepositoryProvider = Provider<PlaceRepository>(
  (_) => MockPlaceRepository(),
);

// Use case providers
final getPlacesUseCaseProvider = Provider(
  (ref) => GetPlacesUseCase(ref.watch(placeRepositoryProvider)),
);

final getPlaceByIdUseCaseProvider = Provider(
  (ref) => GetPlaceByIdUseCase(ref.watch(placeRepositoryProvider)),
);

// Feed places — filtered by category
final feedPlacesProvider = FutureProvider.family<List<PlaceEntity>, PlaceCategoryEntity?>(
  (ref, category) async {
    final useCase = ref.watch(getPlacesUseCaseProvider);
    final result = await useCase(category: category);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (places) => places,
    );
  },
);

// Single place detail
final placeDetailProvider = FutureProvider.family<PlaceEntity, String>(
  (ref, id) async {
    final useCase = ref.watch(getPlaceByIdUseCaseProvider);
    final result = await useCase(id);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (place) => place,
    );
  },
);

// Top rated places
final topRatedPlacesProvider = FutureProvider.family<List<PlaceEntity>, String?>(
  (ref, wilayaId) async {
    final repo = ref.watch(placeRepositoryProvider);
    final result = await repo.getTopRated(wilayaId: wilayaId, limit: 10);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (places) => places,
    );
  },
);

// Similar places
typedef SimilarPlacesParams = ({String placeId, PlaceCategoryEntity category});

final similarPlacesProvider = FutureProvider.family<List<PlaceEntity>, SimilarPlacesParams>(
  (ref, params) async {
    final repo = ref.watch(placeRepositoryProvider);
    final result = await repo.getSimilarPlaces(
      placeId: params.placeId,
      category: params.category,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (places) => places,
    );
  },
);

// Search places
final placeSearchProvider = FutureProvider.family<List<PlaceEntity>, String>(
  (ref, query) async {
    if (query.trim().isEmpty) return [];
    final repo = ref.watch(placeRepositoryProvider);
    final result = await repo.searchPlaces(query);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (places) => places,
    );
  },
);

// Saved places
final savedPlacesProvider = FutureProvider<List<PlaceEntity>>(
  (ref) async {
    final repo = ref.watch(placeRepositoryProvider);
    final result = await repo.getSavedPlaces();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (places) => places,
    );
  },
);
