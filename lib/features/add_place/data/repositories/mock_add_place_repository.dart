import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/new_place_entity.dart';
import '../../domain/repositories/add_place_repository.dart';

class MockAddPlaceRepository implements AddPlaceRepository {
  @override
  Future<Either<Failure, String>> submitPlace(NewPlaceEntity place) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!place.isValid) {
      return const Left(ValidationFailure('Please fill in all required fields'));
    }
    final mockId = 'pending_${DateTime.now().millisecondsSinceEpoch}';
    return Right(mockId);
  }

  @override
  Future<Either<Failure, List<String>>> uploadPhotos(
    String placeId,
    List<String> localPaths,
  ) async {
    await Future.delayed(Duration(milliseconds: 400 * localPaths.length));
    // Return mock URLs (would be Firebase Storage URLs in production)
    final urls = localPaths
        .asMap()
        .entries
        .map((e) =>
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=${e.key}')
        .toList();
    return Right(urls);
  }
}
