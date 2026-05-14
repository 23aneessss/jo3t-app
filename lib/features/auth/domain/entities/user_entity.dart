import 'package:flutter/foundation.dart';

@immutable
class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.wilayaId,
    required this.avatarUrl,
    required this.reviewCount,
    required this.followerCount,
    required this.followingCount,
    required this.jo3tPoints,
    required this.createdAt,
    this.bio,
    this.isFollowedByMe = false,
    this.mutualFollowersCount = 0,
  });

  final String id;
  final String name;
  final String phone;
  final String wilayaId;
  final String avatarUrl;
  final int reviewCount;
  final int followerCount;
  final int followingCount;
  final int jo3tPoints;
  final DateTime createdAt;
  final String? bio;
  final bool isFollowedByMe;
  final int mutualFollowersCount;

  UserEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? wilayaId,
    String? avatarUrl,
    int? reviewCount,
    int? followerCount,
    int? followingCount,
    int? jo3tPoints,
    DateTime? createdAt,
    String? bio,
    bool? isFollowedByMe,
    int? mutualFollowersCount,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      wilayaId: wilayaId ?? this.wilayaId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      reviewCount: reviewCount ?? this.reviewCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      jo3tPoints: jo3tPoints ?? this.jo3tPoints,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      mutualFollowersCount: mutualFollowersCount ?? this.mutualFollowersCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
