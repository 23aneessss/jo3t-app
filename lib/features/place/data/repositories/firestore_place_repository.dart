import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';

class FirestorePlaceRepository implements PlaceRepository {
  final FirebaseFirestore _db;

  FirestorePlaceRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _places =>
      _db.collection('places');

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    PlaceCategoryEntity? category,
    String? wilayaId,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _places.where('isApproved', isEqualTo: true);

      if (category != null) {
        query = query.where('category', isEqualTo: category.name);
      }
      if (wilayaId != null) {
        query = query.where('wilayaId', isEqualTo: wilayaId);
      }

      query = query.orderBy('jo3tScore', descending: true).limit(limit);

      if (cursor != null) {
        final cursorDoc = await _places.doc(cursor).get();
        query = query.startAfterDocument(cursorDoc);
      }

      final snap = await query.get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceById(String id) async {
    try {
      final doc = await _places.doc(id).get();
      if (!doc.exists) return const Left(NotFoundFailure('Place not found'));
      return Right(_fromDoc(doc));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getTopRated({
    String? wilayaId,
    int limit = 10,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _places.where('isApproved', isEqualTo: true);
      if (wilayaId != null) {
        query = query.where('wilayaId', isEqualTo: wilayaId);
      }
      final snap = await query
          .orderBy('jo3tScore', descending: true)
          .limit(limit)
          .get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getSimilarPlaces({
    required String placeId,
    required PlaceCategoryEntity category,
    int limit = 10,
  }) async {
    try {
      final snap = await _places
          .where('isApproved', isEqualTo: true)
          .where('category', isEqualTo: category.name)
          .where(FieldPath.documentId, isNotEqualTo: placeId)
          .limit(limit)
          .get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    try {
      final q = query.toLowerCase();
      final snap = await _places
          .where('isApproved', isEqualTo: true)
          .orderBy('jo3tScore', descending: true)
          .limit(100)
          .get();
      final results = snap.docs
          .map(_fromDoc)
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.wilayaId.toLowerCase().contains(q) ||
              p.category.label.toLowerCase().contains(q))
          .toList();
      return Right(results);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  }) async {
    // Firestore doesn't support native geo queries — fetch recent and let
    // the caller filter by distance using the lat/lng fields.
    try {
      final snap = await _places
          .where('isApproved', isEqualTo: true)
          .orderBy('jo3tScore', descending: true)
          .limit(50)
          .get();
      return Right(snap.docs.map(_fromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, String>> addPlace(PlaceEntity place) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final ref = _db.collection('places_pending').doc();
      await ref.set({
        'name': place.name,
        'category': place.category.name,
        'wilayaId': place.wilayaId,
        'neighborhood': place.neighborhood,
        'address': place.address,
        'priceRange': place.priceRange.name,
        'latitude': place.latitude,
        'longitude': place.longitude,
        'photos': place.photos,
        'coverPhotoUrl': place.coverPhotoUrl,
        'submittedBy': uid,
        'submittedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'isApproved': false,
        'jo3tScore': 0.0,
        'averageScore': 0.0,
        'reviewCount': 0,
      });
      return Right(ref.id);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Submit failed'));
    }
  }

  @override
  Future<Either<Failure, void>> savePlace(String placeId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return const Left(AuthFailure('Not authenticated'));
      await _db.collection('users').doc(uid).update({
        'savedPlaceIds': FieldValue.arrayUnion([placeId]),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Save failed'));
    }
  }

  @override
  Future<Either<Failure, void>> unsavePlace(String placeId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return const Left(AuthFailure('Not authenticated'));
      await _db.collection('users').doc(uid).update({
        'savedPlaceIds': FieldValue.arrayRemove([placeId]),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unsave failed'));
    }
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getSavedPlaces() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return const Right([]);

      final userDoc = await _db.collection('users').doc(uid).get();
      final savedIds =
          List<String>.from(userDoc.data()?['savedPlaceIds'] ?? []);
      if (savedIds.isEmpty) return const Right([]);

      final snaps = await Future.wait(
        savedIds.map((id) => _places.doc(id).get()),
      );
      final places = snaps
          .where((d) => d.exists)
          .map(_fromDoc)
          .toList();
      return Right(places);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  PlaceEntity _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final ts = d['createdAt'] as Timestamp?;
    return PlaceEntity(
      id: doc.id,
      name: d['name'] as String? ?? '',
      category: PlaceCategoryEntity.values.firstWhere(
        (c) => c.name == d['category'],
        orElse: () => PlaceCategoryEntity.restaurant,
      ),
      wilayaId: d['wilayaId'] as String? ?? '',
      neighborhood: d['neighborhood'] as String? ?? '',
      address: d['address'] as String? ?? '',
      averageScore: (d['averageScore'] as num?)?.toDouble() ?? 0,
      reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
      jo3tScore: (d['jo3tScore'] as num?)?.toDouble() ?? 0,
      coverPhotoUrl: d['coverPhotoUrl'] as String? ?? '',
      photos: List<String>.from(d['photos'] ?? []),
      priceRange: PriceRangeEntity.values.firstWhere(
        (p) => p.name == d['priceRange'],
        orElse: () => PriceRangeEntity.mid,
      ),
      status: PlaceStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => PlaceStatus.active,
      ),
      isVerified: d['isVerified'] as bool? ?? false,
      addedBy: d['addedBy'] as String? ?? d['submittedBy'] as String? ?? '',
      createdAt: ts?.toDate() ?? DateTime.now(),
      latitude: (d['latitude'] as num?)?.toDouble(),
      longitude: (d['longitude'] as num?)?.toDouble(),
      isOpen: d['isOpen'] as bool?,
      openUntil: d['openUntil'] as String?,
    );
  }
}
