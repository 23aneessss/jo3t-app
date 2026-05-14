import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class GetPlacesUseCase {
  const GetPlacesUseCase(this._repository);
  final PlaceRepository _repository;

  Future<Either<Failure, List<PlaceEntity>>> call({
    PlaceCategoryEntity? category,
    String? wilayaId,
    int limit = 20,
    String? cursor,
  }) =>
      _repository.getPlaces(
        category: category,
        wilayaId: wilayaId,
        limit: limit,
        cursor: cursor,
      );
}
