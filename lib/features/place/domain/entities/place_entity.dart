import 'package:flutter/foundation.dart';

enum PlaceCategoryEntity {
  restaurant,
  cafe,
  patisserie,
  sandwich,
  streetFood,
  juiceBar;

  String get label => switch (this) {
        PlaceCategoryEntity.restaurant => 'Restaurant',
        PlaceCategoryEntity.cafe => 'Café',
        PlaceCategoryEntity.patisserie => 'Patisserie',
        PlaceCategoryEntity.sandwich => 'Sandwich',
        PlaceCategoryEntity.streetFood => 'Street Food',
        PlaceCategoryEntity.juiceBar => 'Juice Bar',
      };
}

enum PriceRangeEntity { budget, mid, premium }

extension PriceRangeEntityX on PriceRangeEntity {
  String get label => switch (this) {
        PriceRangeEntity.budget => '€',
        PriceRangeEntity.mid => '€€',
        PriceRangeEntity.premium => '€€€',
      };
}

enum PlaceStatus { pending, active, flagged, closed }

@immutable
class PlaceEntity {
  const PlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.wilayaId,
    required this.neighborhood,
    required this.address,
    required this.averageScore,
    required this.reviewCount,
    required this.jo3tScore,
    required this.coverPhotoUrl,
    required this.photos,
    required this.priceRange,
    required this.status,
    required this.isVerified,
    required this.addedBy,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.isOpen,
    this.openUntil,
    this.distance,
  });

  final String id;
  final String name;
  final PlaceCategoryEntity category;
  final String wilayaId;
  final String neighborhood;
  final String address;
  final double averageScore;
  final int reviewCount;
  final double jo3tScore;
  final String coverPhotoUrl;
  final List<String> photos;
  final PriceRangeEntity priceRange;
  final PlaceStatus status;
  final bool isVerified;
  final String addedBy;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final bool? isOpen;
  final String? openUntil;
  final String? distance;

  PlaceEntity copyWith({
    String? id,
    String? name,
    PlaceCategoryEntity? category,
    String? wilayaId,
    String? neighborhood,
    String? address,
    double? averageScore,
    int? reviewCount,
    double? jo3tScore,
    String? coverPhotoUrl,
    List<String>? photos,
    PriceRangeEntity? priceRange,
    PlaceStatus? status,
    bool? isVerified,
    String? addedBy,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    bool? isOpen,
    String? openUntil,
    String? distance,
  }) {
    return PlaceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      wilayaId: wilayaId ?? this.wilayaId,
      neighborhood: neighborhood ?? this.neighborhood,
      address: address ?? this.address,
      averageScore: averageScore ?? this.averageScore,
      reviewCount: reviewCount ?? this.reviewCount,
      jo3tScore: jo3tScore ?? this.jo3tScore,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      photos: photos ?? this.photos,
      priceRange: priceRange ?? this.priceRange,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOpen: isOpen ?? this.isOpen,
      openUntil: openUntil ?? this.openUntil,
      distance: distance ?? this.distance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlaceEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
