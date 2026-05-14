import 'package:flutter/foundation.dart';
import '../../../place/domain/entities/place_entity.dart';

@immutable
class DiscoveryFilters {
  const DiscoveryFilters({
    this.category,
    this.wilayaId,
    this.nearMe = false,
  });

  final PlaceCategoryEntity? category;
  final String? wilayaId;
  final bool nearMe;

  DiscoveryFilters copyWith({
    PlaceCategoryEntity? category,
    bool clearCategory = false,
    String? wilayaId,
    bool clearWilaya = false,
    bool? nearMe,
  }) {
    return DiscoveryFilters(
      category: clearCategory ? null : (category ?? this.category),
      wilayaId: clearWilaya ? null : (wilayaId ?? this.wilayaId),
      nearMe: nearMe ?? this.nearMe,
    );
  }

  bool get hasFilters => category != null || wilayaId != null || nearMe;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveryFilters &&
          other.category == category &&
          other.wilayaId == wilayaId &&
          other.nearMe == nearMe;

  @override
  int get hashCode => Object.hash(category, wilayaId, nearMe);
}
