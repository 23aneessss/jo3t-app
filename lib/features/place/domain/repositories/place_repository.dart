import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/place_entity.dart';

abstract interface class PlaceRepository {
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    PlaceCategoryEntity? category,
    String? wilayaId,
    int limit = 20,
    String? cursor,
  });

  Future<Either<Failure, PlaceEntity>> getPlaceById(String id);

  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query);

  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  });

  Future<Either<Failure, List<PlaceEntity>>> getTopRated({
    String? wilayaId,
    int limit = 10,
  });

  Future<Either<Failure, List<PlaceEntity>>> getSimilarPlaces({
    required String placeId,
    required PlaceCategoryEntity category,
    int limit = 10,
  });

  Future<Either<Failure, String>> addPlace(PlaceEntity place);

  Future<Either<Failure, void>> savePlace(String placeId);

  Future<Either<Failure, void>> unsavePlace(String placeId);

  Future<Either<Failure, List<PlaceEntity>>> getSavedPlaces();
}
