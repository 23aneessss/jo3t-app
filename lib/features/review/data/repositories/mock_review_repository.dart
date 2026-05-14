import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';

class MockReviewRepository implements ReviewRepository {
  static final _reviews = <ReviewEntity>[
    ReviewEntity(
      id: 'review_1',
      placeId: 'place_1',
      userId: 'user_2',
      userName: 'Sara Benali',
      userAvatar: '',
      score: 9.0,
      text: 'Ambiance incroyable, service impeccable. Le couscous royal était fantastique, je recommande vivement ! Un endroit qui mérite vraiment sa réputation.',
      photos: [
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      ],
      likeCount: 24,
      createdAt: DateTime(2024, 11, 10),
      isLikedByMe: false,
    ),
    ReviewEntity(
      id: 'review_2',
      placeId: 'place_1',
      userId: 'user_3',
      userName: 'Amine Kader',
      userAvatar: '',
      score: 8.5,
      text: 'Très bon restaurant, les plats sont bien présentés et savoureux. Prix un peu élevés mais ça vaut le coup pour une occasion spéciale.',
      photos: [],
      likeCount: 11,
      createdAt: DateTime(2024, 11, 5),
      isLikedByMe: true,
    ),
    ReviewEntity(
      id: 'review_3',
      placeId: 'place_1',
      userId: 'user_4',
      userName: 'Nadia Haddad',
      userAvatar: '',
      score: 8.0,
      text: 'Super cadre, personnel accueillant. Le dessert maison était exceptionnel.',
      photos: [
        'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=400',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      ],
      likeCount: 7,
      createdAt: DateTime(2024, 10, 28),
      isLikedByMe: false,
    ),
    ReviewEntity(
      id: 'review_4',
      placeId: 'place_3',
      userId: 'user_1',
      userName: 'Karim Mansouri',
      userAvatar: '',
      score: 9.5,
      text: 'La meilleure pâtisserie d\'Alger sans hésitation. Les mille-feuilles sont divins !',
      photos: [],
      likeCount: 38,
      createdAt: DateTime(2024, 11, 12),
      isLikedByMe: false,
    ),
    ReviewEntity(
      id: 'review_5',
      placeId: 'place_5',
      userId: 'user_2',
      userName: 'Sara Benali',
      userAvatar: '',
      score: 8.0,
      text: 'Jus frais et délicieux, prix abordables. Idéal pour une pause rapide.',
      photos: [],
      likeCount: 5,
      createdAt: DateTime(2024, 11, 8),
      isLikedByMe: false,
    ),
  ];

  final _likedIds = <String>{};

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForPlace(
    String placeId, {
    int limit = 20,
    String? cursor,
    ReviewSortOrder sortOrder = ReviewSortOrder.newest,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var result = _reviews.where((r) => r.placeId == placeId).toList();
    switch (sortOrder) {
      case ReviewSortOrder.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case ReviewSortOrder.highest:
        result.sort((a, b) => b.score.compareTo(a.score));
      case ReviewSortOrder.lowest:
        result.sort((a, b) => a.score.compareTo(b.score));
    }
    return Right(result.take(limit).toList());
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser(
    String userId, {
    int limit = 20,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final result = _reviews.where((r) => r.userId == userId).take(limit).toList();
    return Right(result);
  }

  @override
  Future<Either<Failure, ReviewEntity>> getReviewById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final review = _reviews.where((r) => r.id == id).firstOrNull;
    if (review == null) return const Left(NotFoundFailure('Review not found'));
    return Right(review);
  }

  @override
  Future<Either<Failure, String>> submitReview({
    required String placeId,
    required double score,
    required String text,
    List<String> photoPaths = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newId = 'review_${DateTime.now().millisecondsSinceEpoch}';
    return Right(newId);
  }

  @override
  Future<Either<Failure, void>> likeReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _likedIds.add(reviewId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unlikeReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _likedIds.remove(reviewId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right(null);
  }
}
