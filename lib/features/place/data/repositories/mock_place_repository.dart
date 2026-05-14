import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';

class MockPlaceRepository implements PlaceRepository {
  static final _places = <PlaceEntity>[
    PlaceEntity(
      id: 'place_1',
      name: 'Le Tandem',
      category: PlaceCategoryEntity.restaurant,
      wilayaId: 'alger',
      neighborhood: 'Hydra',
      address: '12 Rue des Glycines, Hydra, Alger',
      averageScore: 8.7,
      reviewCount: 142,
      jo3tScore: 8.9,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
      photos: [
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800',
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800',
      ],
      priceRange: PriceRangeEntity.premium,
      status: PlaceStatus.active,
      isVerified: true,
      addedBy: 'user_1',
      createdAt: DateTime(2024, 3, 15),
      latitude: 36.7413,
      longitude: 3.0477,
      isOpen: true,
      openUntil: '23:00',
    ),
    PlaceEntity(
      id: 'place_2',
      name: 'Café Glacier',
      category: PlaceCategoryEntity.cafe,
      wilayaId: 'alger',
      neighborhood: 'Bab El Oued',
      address: '5 Place des Martyrs, Bab El Oued',
      averageScore: 7.8,
      reviewCount: 89,
      jo3tScore: 7.6,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800',
      photos: [
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800',
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      ],
      priceRange: PriceRangeEntity.budget,
      status: PlaceStatus.active,
      isVerified: true,
      addedBy: 'user_2',
      createdAt: DateTime(2024, 4, 1),
      latitude: 36.7787,
      longitude: 3.0568,
      isOpen: true,
      openUntil: '22:00',
    ),
    PlaceEntity(
      id: 'place_3',
      name: 'Pâtisserie Hannachi',
      category: PlaceCategoryEntity.patisserie,
      wilayaId: 'alger',
      neighborhood: 'Didouche Mourad',
      address: '18 Rue Didouche Mourad',
      averageScore: 9.1,
      reviewCount: 234,
      jo3tScore: 9.3,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800',
      photos: [
        'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800',
        'https://images.unsplash.com/photo-1567327613485-fbc7bf196198?w=800',
      ],
      priceRange: PriceRangeEntity.mid,
      status: PlaceStatus.active,
      isVerified: true,
      addedBy: 'user_3',
      createdAt: DateTime(2024, 1, 10),
      isOpen: false,
      openUntil: '20:00',
    ),
    PlaceEntity(
      id: 'place_4',
      name: 'Snack Olympique',
      category: PlaceCategoryEntity.sandwich,
      wilayaId: 'oran',
      neighborhood: 'Plateau',
      address: '7 Rue Mohamed Khemisti, Oran',
      averageScore: 7.2,
      reviewCount: 61,
      jo3tScore: 7.0,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=800',
      photos: [
        'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=800',
      ],
      priceRange: PriceRangeEntity.budget,
      status: PlaceStatus.active,
      isVerified: false,
      addedBy: 'user_4',
      createdAt: DateTime(2024, 5, 20),
      isOpen: true,
      openUntil: '21:30',
    ),
    PlaceEntity(
      id: 'place_5',
      name: 'Jus Palais',
      category: PlaceCategoryEntity.juiceBar,
      wilayaId: 'alger',
      neighborhood: 'Kouba',
      address: '3 Avenue Mustapha Khalef, Kouba',
      averageScore: 8.4,
      reviewCount: 178,
      jo3tScore: 8.5,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1560717845-968823efbee1?w=800',
      photos: [
        'https://images.unsplash.com/photo-1560717845-968823efbee1?w=800',
        'https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=800',
      ],
      priceRange: PriceRangeEntity.budget,
      status: PlaceStatus.active,
      isVerified: true,
      addedBy: 'user_5',
      createdAt: DateTime(2024, 2, 28),
      isOpen: true,
      openUntil: '23:30',
      distance: '0.8 km',
    ),
    PlaceEntity(
      id: 'place_6',
      name: 'El Bahdja',
      category: PlaceCategoryEntity.restaurant,
      wilayaId: 'alger',
      neighborhood: 'El Biar',
      address: '24 Chemin Ahmed Kara, El Biar',
      averageScore: 8.0,
      reviewCount: 95,
      jo3tScore: 8.1,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
      photos: [
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800',
        'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
      ],
      priceRange: PriceRangeEntity.mid,
      status: PlaceStatus.active,
      isVerified: true,
      addedBy: 'user_1',
      createdAt: DateTime(2024, 6, 5),
      isOpen: true,
      openUntil: '00:00',
      distance: '2.1 km',
    ),
    PlaceEntity(
      id: 'place_7',
      name: 'Street Eats DZ',
      category: PlaceCategoryEntity.streetFood,
      wilayaId: 'constantine',
      neighborhood: 'Centre-ville',
      address: 'Rue Larbi Ben M\'hidi, Constantine',
      averageScore: 8.6,
      reviewCount: 112,
      jo3tScore: 8.4,
      coverPhotoUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      photos: [
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      ],
      priceRange: PriceRangeEntity.budget,
      status: PlaceStatus.active,
      isVerified: false,
      addedBy: 'user_2',
      createdAt: DateTime(2024, 4, 18),
      isOpen: true,
      openUntil: '20:00',
    ),
  ];

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    PlaceCategoryEntity? category,
    String? wilayaId,
    int limit = 20,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    var result = List<PlaceEntity>.from(_places);
    if (category != null) result = result.where((p) => p.category == category).toList();
    if (wilayaId != null) result = result.where((p) => p.wilayaId == wilayaId).toList();
    return Right(result.take(limit).toList());
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final place = _places.where((p) => p.id == id).firstOrNull;
    if (place == null) return const Left(NotFoundFailure('Place not found'));
    return Right(place);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = query.toLowerCase();
    final results = _places.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.neighborhood.toLowerCase().contains(q) ||
        p.address.toLowerCase().contains(q)).toList();
    return Right(results);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final nearby = _places.where((p) => p.latitude != null && p.longitude != null).toList();
    return Right(nearby);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getTopRated({
    String? wilayaId,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var result = List<PlaceEntity>.from(_places);
    if (wilayaId != null) result = result.where((p) => p.wilayaId == wilayaId).toList();
    result.sort((a, b) => b.jo3tScore.compareTo(a.jo3tScore));
    return Right(result.take(limit).toList());
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getSimilarPlaces({
    required String placeId,
    required PlaceCategoryEntity category,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final similar = _places
        .where((p) => p.id != placeId && p.category == category)
        .take(limit)
        .toList();
    return Right(similar);
  }

  @override
  Future<Either<Failure, String>> addPlace(PlaceEntity place) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const Right('pending_review');
  }

  final _savedIds = <String>{};

  @override
  Future<Either<Failure, void>> savePlace(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _savedIds.add(placeId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unsavePlace(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _savedIds.remove(placeId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getSavedPlaces() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final saved = _places.where((p) => _savedIds.contains(p.id)).toList();
    return Right(saved);
  }
}
