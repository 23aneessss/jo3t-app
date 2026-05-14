import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetReviewsUseCase {
  const GetReviewsUseCase(this._repository);
  final ReviewRepository _repository;

  Future<Either<Failure, List<ReviewEntity>>> call(
    String placeId, {
    int limit = 20,
    String? cursor,
    ReviewSortOrder sortOrder = ReviewSortOrder.newest,
  }) =>
      _repository.getReviewsForPlace(
        placeId,
        limit: limit,
        cursor: cursor,
        sortOrder: sortOrder,
      );
}
