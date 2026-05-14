import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/new_place_entity.dart';

abstract interface class AddPlaceRepository {
  Future<Either<Failure, String>> submitPlace(NewPlaceEntity place);

  Future<Either<Failure, List<String>>> uploadPhotos(
    String placeId,
    List<String> localPaths,
  );
}
