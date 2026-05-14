import 'package:flutter/foundation.dart';
import '../../../place/domain/entities/place_entity.dart';

@immutable
class NewPlaceEntity {
  const NewPlaceEntity({
    required this.name,
    required this.category,
    required this.wilayaId,
    required this.neighborhood,
    required this.address,
    required this.priceRange,
    this.latitude,
    this.longitude,
    this.photoPaths = const [],
    this.description,
  });

  final String name;
  final PlaceCategoryEntity category;
  final String wilayaId;
  final String neighborhood;
  final String address;
  final PriceRangeEntity priceRange;
  final double? latitude;
  final double? longitude;
  final List<String> photoPaths;
  final String? description;

  NewPlaceEntity copyWith({
    String? name,
    PlaceCategoryEntity? category,
    String? wilayaId,
    String? neighborhood,
    String? address,
    PriceRangeEntity? priceRange,
    double? latitude,
    double? longitude,
    List<String>? photoPaths,
    String? description,
  }) {
    return NewPlaceEntity(
      name: name ?? this.name,
      category: category ?? this.category,
      wilayaId: wilayaId ?? this.wilayaId,
      neighborhood: neighborhood ?? this.neighborhood,
      address: address ?? this.address,
      priceRange: priceRange ?? this.priceRange,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPaths: photoPaths ?? this.photoPaths,
      description: description ?? this.description,
    );
  }

  bool get isValid =>
      name.trim().isNotEmpty &&
      wilayaId.isNotEmpty &&
      neighborhood.trim().isNotEmpty &&
      address.trim().isNotEmpty;
}
