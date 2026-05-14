import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';

abstract interface class ReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForPlace(
    String placeId, {
    int limit = 20,
    String? cursor,
    ReviewSortOrder sortOrder = ReviewSortOrder.newest,
  });

  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser(
    String userId, {
    int limit = 20,
    String? cursor,
  });

  Future<Either<Failure, ReviewEntity>> getReviewById(String id);

  Future<Either<Failure, String>> submitReview({
    required String placeId,
    required double score,
    required String text,
    List<String> photoPaths = const [],
  });

  Future<Either<Failure, void>> likeReview(String reviewId);

  Future<Either<Failure, void>> unlikeReview(String reviewId);

  Future<Either<Failure, void>> deleteReview(String reviewId);
}

enum ReviewSortOrder { newest, highest, lowest }
