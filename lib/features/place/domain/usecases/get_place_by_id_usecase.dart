import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/place_entity.dart';
import '../repositories/place_repository.dart';

class GetPlaceByIdUseCase {
  const GetPlaceByIdUseCase(this._repository);
  final PlaceRepository _repository;

  Future<Either<Failure, PlaceEntity>> call(String id) =>
      _repository.getPlaceById(id);
}
