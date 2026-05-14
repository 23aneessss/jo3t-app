import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static final _mockUser = UserEntity(
    id: 'current_user',
    name: 'Youcef Amrani',
    phone: '+213 555 012 345',
    wilayaId: 'alger',
    avatarUrl: '',
    reviewCount: 12,
    followerCount: 48,
    followingCount: 31,
    jo3tPoints: 1240,
    createdAt: DateTime(2024, 1, 15),
    bio: 'Food lover from Alger. Always hunting for the best couscous.',
  );

  static final _mockUsers = <String, UserEntity>{
    'user_1': UserEntity(id: 'user_1', name: 'Karim Mansouri', phone: '', wilayaId: 'alger', avatarUrl: '', reviewCount: 34, followerCount: 120, followingCount: 67, jo3tPoints: 3400, createdAt: DateTime(2023, 6, 1)),
    'user_2': UserEntity(id: 'user_2', name: 'Sara Benali', phone: '', wilayaId: 'oran', avatarUrl: '', reviewCount: 28, followerCount: 89, followingCount: 45, jo3tPoints: 2800, createdAt: DateTime(2023, 8, 15)),
    'user_3': UserEntity(id: 'user_3', name: 'Amine Kader', phone: '', wilayaId: 'constantine', avatarUrl: '', reviewCount: 19, followerCount: 56, followingCount: 32, jo3tPoints: 1900, createdAt: DateTime(2024, 2, 10)),
    'user_4': UserEntity(id: 'user_4', name: 'Nadia Haddad', phone: '', wilayaId: 'alger', avatarUrl: '', reviewCount: 41, followerCount: 200, followingCount: 88, jo3tPoints: 4100, createdAt: DateTime(2023, 3, 20)),
    'user_5': UserEntity(id: 'user_5', name: 'Mohamed Cherif', phone: '', wilayaId: 'blida', avatarUrl: '', reviewCount: 8, followerCount: 22, followingCount: 15, jo3tPoints: 800, createdAt: DateTime(2024, 5, 1)),
  };

  UserEntity? _currentUser = _mockUser;
  final _following = <String>{};

  @override
  Future<Either<Failure, String>> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const Right('mock_verification_id');
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (otp == '000000') {
      return const Left(AuthFailure('Invalid OTP'));
    }
    _currentUser = _mockUser;
    return Right(_mockUser);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    _currentUser = _mockUser;
    return Right(_mockUser);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return Right(_currentUser);
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? wilayaId,
    String? avatarPath,
    String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_currentUser == null) return const Left(AuthFailure());
    _currentUser = _currentUser!.copyWith(
      name: name,
      wilayaId: wilayaId,
      bio: bio,
    );
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _following.add(userId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _following.remove(userId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFollowers(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_mockUsers.values.take(3).toList());
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFollowing(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(_mockUsers.values.skip(1).take(4).toList());
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final q = query.toLowerCase();
    final results = _mockUsers.values
        .where((u) => u.name.toLowerCase().contains(q))
        .toList();
    return Right(results);
  }
}
