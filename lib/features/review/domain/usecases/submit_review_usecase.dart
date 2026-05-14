import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/review_repository.dart';

class SubmitReviewUseCase {
  const SubmitReviewUseCase(this._repository);
  final ReviewRepository _repository;

  Future<Either<Failure, String>> call({
    required String placeId,
    required double score,
    required String text,
    List<String> photoPaths = const [],
  }) =>
      _repository.submitReview(
        placeId: placeId,
        score: score,
        text: text,
        photoPaths: photoPaths,
      );
}
