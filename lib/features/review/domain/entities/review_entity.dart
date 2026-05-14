import 'package:flutter/foundation.dart';

@immutable
class ReviewEntity {
  const ReviewEntity({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.score,
    required this.text,
    required this.photos,
    required this.likeCount,
    required this.createdAt,
    this.isLikedByMe = false,
  });

  final String id;
  final String placeId;
  final String userId;
  final String userName;
  final String userAvatar;
  final double score;
  final String text;
  final List<String> photos;
  final int likeCount;
  final DateTime createdAt;
  final bool isLikedByMe;

  ReviewEntity copyWith({
    String? id,
    String? placeId,
    String? userId,
    String? userName,
    String? userAvatar,
    double? score,
    String? text,
    List<String>? photos,
    int? likeCount,
    DateTime? createdAt,
    bool? isLikedByMe,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      score: score ?? this.score,
      text: text ?? this.text,
      photos: photos ?? this.photos,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReviewEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
