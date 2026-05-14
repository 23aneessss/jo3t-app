import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/new_place_entity.dart';
import '../repositories/add_place_repository.dart';

class SubmitPlaceUseCase {
  const SubmitPlaceUseCase(this._repository);
  final AddPlaceRepository _repository;

  Future<Either<Failure, String>> call(NewPlaceEntity place) =>
      _repository.submitPlace(place);
}
