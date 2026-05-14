import 'package:flutter/foundation.dart';

@immutable
class WilayaEntity {
  const WilayaEntity({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.code,
    this.placeCount = 0,
    this.topPlaceIds = const [],
  });

  final String id;
  final String nameFr;
  final String nameAr;
  final String code;
  final int placeCount;
  final List<String> topPlaceIds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WilayaEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
