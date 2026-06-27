import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';

class FirestoreReviewRepository implements ReviewRepository {
  final FirebaseFirestore _db;

  FirestoreReviewRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reviews =>
      _db.collection('reviews');

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForPlace(
    String placeId, {
    int limit = 20,
    String? cursor,
    ReviewSortOrder sortOrder = ReviewSortOrder.newest,
  }) async {
    try {
      final orderField = switch (sortOrder) {
        ReviewSortOrder.newest => 'createdAt',
        ReviewSortOrder.highest => 'score',
        ReviewSortOrder.lowest => 'score',
      };
      final descending = sortOrder != ReviewSortOrder.lowest;

      var query = _reviews
          .where('placeId', isEqualTo: placeId)
          .orderBy(orderField, descending: descending)
          .limit(limit);

      if (cursor != null) {
        final cursorDoc = await _reviews.doc(cursor).get();
        query = query.startAfterDocument(cursorDoc);
      }

      final snap = await query.get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser(
    String userId, {
    int limit = 20,
    String? cursor,
  }) async {
    try {
      var query = _reviews
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (cursor != null) {
        final cursorDoc = await _reviews.doc(cursor).get();
        query = query.startAfterDocument(cursorDoc);
      }

      final snap = await query.get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> getReviewById(String id) async {
    try {
      final doc = await _reviews.doc(id).get();
      if (!doc.exists) {
        return const Left(NotFoundFailure('Review not found'));
      }
      return Right(_fromDoc(doc));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, String>> submitReview({
    required String placeId,
    required double score,
    required String text,
    List<String> photoPaths = const [],
  }) async {
    try {
      final ref = _reviews.doc();
      await ref.set({
        'placeId': placeId,
        'score': score,
        'text': text,
        'photos': photoPaths,
        'likeCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return Right(ref.id);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, void>> likeReview(String reviewId) async {
    try {
      await _reviews.doc(reviewId).update({
        'likeCount': FieldValue.increment(1),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeReview(String reviewId) async {
    try {
      await _reviews.doc(reviewId).update({
        'likeCount': FieldValue.increment(-1),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await _reviews.doc(reviewId).delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  ReviewEntity _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final ts = d['createdAt'] as Timestamp?;
    return ReviewEntity(
      id: doc.id,
      placeId: d['placeId'] as String? ?? '',
      userId: d['userId'] as String? ?? '',
      userName: d['userName'] as String? ?? 'Anonymous',
      userAvatar: d['userAvatar'] as String? ?? '',
      score: (d['score'] as num).toDouble(),
      text: d['text'] as String? ?? '',
      photos: List<String>.from(d['photos'] ?? []),
      likeCount: (d['likeCount'] as num?)?.toInt() ?? 0,
      createdAt: ts?.toDate() ?? DateTime.now(),
      isLikedByMe: false,
    );
  }
}
