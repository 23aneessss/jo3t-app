import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> sendOtp(String phone);

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String otp,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? wilayaId,
    String? avatarPath,
    String? bio,
  });

  Future<Either<Failure, void>> followUser(String userId);

  Future<Either<Failure, void>> unfollowUser(String userId);

  Future<Either<Failure, List<UserEntity>>> getFollowers(String userId);

  Future<Either<Failure, List<UserEntity>>> getFollowing(String userId);

  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}
