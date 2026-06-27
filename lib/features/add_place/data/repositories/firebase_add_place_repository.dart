import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/new_place_entity.dart';
import '../../domain/repositories/add_place_repository.dart';

class FirebaseAddPlaceRepository implements AddPlaceRepository {
  final FirebaseFirestore _db;
  final StorageService _storage;

  FirebaseAddPlaceRepository({
    FirebaseFirestore? db,
    StorageService? storage,
  })  : _db = db ?? FirebaseFirestore.instance,
        _storage = storage ?? StorageService();

  @override
  Future<Either<Failure, String>> submitPlace(NewPlaceEntity place) async {
    if (!place.isValid) {
      return const Left(ValidationFailure('Place data is incomplete'));
    }
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
        'description': place.description,
        'photos': [],
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
  Future<Either<Failure, List<String>>> uploadPhotos(
      String placeId, List<String> localPaths) async {
    if (localPaths.isEmpty) return const Right([]);

    final result = await _storage.uploadPhotos(
      localPaths: localPaths,
      folder: 'places/$placeId',
    );

    return result.fold(
      (failure) => Left(failure),
      (urls) async {
        await _db.collection('places_pending').doc(placeId).update({
          'photos': urls,
          'coverPhotoUrl': urls.first,
        });
        return Right(urls);
      },
    );
  }
}
