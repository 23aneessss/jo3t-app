import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_env.dart';
import '../../data/repositories/firestore_review_repository.dart';
import '../../data/repositories/mock_review_repository.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/get_reviews_usecase.dart';
import '../../domain/usecases/submit_review_usecase.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (_) => AppEnv.useFirebase
      ? FirestoreReviewRepository()
      : MockReviewRepository(),
);

final getReviewsUseCaseProvider = Provider(
  (ref) => GetReviewsUseCase(ref.watch(reviewRepositoryProvider)),
);

final submitReviewUseCaseProvider = Provider(
  (ref) => SubmitReviewUseCase(ref.watch(reviewRepositoryProvider)),
);

typedef ReviewsParams = ({String placeId, ReviewSortOrder sortOrder});

final placeReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, ReviewsParams>(
  (ref, params) async {
    final useCase = ref.watch(getReviewsUseCaseProvider);
    final result = await useCase(
      params.placeId,
      sortOrder: params.sortOrder,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (reviews) => reviews,
    );
  },
);

final userReviewsProvider =
    FutureProvider.family<List<ReviewEntity>, String>(
  (ref, userId) async {
    final repo = ref.watch(reviewRepositoryProvider);
    final result = await repo.getReviewsByUser(userId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (reviews) => reviews,
    );
  },
);

class SubmitReviewNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit({
    required String placeId,
    required double score,
    required String text,
    List<String> photoPaths = const [],
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(submitReviewUseCaseProvider);
    final result = await useCase(
      placeId: placeId,
      score: score,
      text: text,
      photoPaths: photoPaths,
    );
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncData(null);
        ref.invalidate(placeReviewsProvider);
        return true;
      },
    );
  }
}

final submitReviewNotifierProvider =
    AsyncNotifierProvider<SubmitReviewNotifier, void>(
        SubmitReviewNotifier.new);
