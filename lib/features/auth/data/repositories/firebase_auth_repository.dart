import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final StorageService _storage;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
    StorageService? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance,
        _storage = storage ?? StorageService();

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return const Right(null);
      return Right(await _fetchUserEntity(user.uid));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    return const Left(AuthFailure('Google Sign-In not yet configured'));
  }

  @override
  Future<Either<Failure, String>> sendOtp(String phone) async {
    final completer = Completer<Either<Failure, String>>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        if (!completer.isCompleted) {
          completer.complete(const Right('auto-verified'));
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer
              .complete(Left(AuthFailure(e.message ?? 'OTP failed')));
        }
      },
      codeSent: (verificationId, _) {
        if (!completer.isCompleted) {
          completer.complete(Right(verificationId));
        }
      },
      codeAutoRetrievalTimeout: (_) {
        if (!completer.isCompleted) {
          completer.complete(const Left(AuthFailure('OTP timeout')));
        }
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = result.user!;

      final userDoc = _db.collection('users').doc(user.uid);
      final snap = await userDoc.get();
      if (!snap.exists) {
        await userDoc.set({
          'name': '',
          'phone': user.phoneNumber ?? '',
          'wilayaId': '',
          'avatarUrl': '',
          'reviewCount': 0,
          'followerCount': 0,
          'followingCount': 0,
          'jo3tPoints': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'savedPlaceIds': [],
          'following': [],
          'followers': [],
        });
      }

      return Right(await _fetchUserEntity(user.uid));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'OTP verification failed'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? wilayaId,
    String? avatarPath,
    String? bio,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left(AuthFailure('Not authenticated'));

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (wilayaId != null) updates['wilayaId'] = wilayaId;
      if (bio != null) updates['bio'] = bio;

      if (avatarPath != null) {
        final uploadResult = await _storage.uploadPhoto(
          localPath: avatarPath,
          remotePath: 'avatars/$uid.jpg',
        );
        uploadResult.fold(
          (_) {},
          (url) => updates['avatarUrl'] = url,
        );
      }

      if (updates.isNotEmpty) {
        await _db.collection('users').doc(uid).update(updates);
      }
      return Right(await _fetchUserEntity(uid));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Profile update failed'));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left(AuthFailure('Not authenticated'));

      final batch = _db.batch();
      batch.update(_db.collection('users').doc(uid), {
        'followingCount': FieldValue.increment(1),
        'following': FieldValue.arrayUnion([userId]),
      });
      batch.update(_db.collection('users').doc(userId), {
        'followerCount': FieldValue.increment(1),
        'followers': FieldValue.arrayUnion([uid]),
      });
      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Follow failed'));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left(AuthFailure('Not authenticated'));

      final batch = _db.batch();
      batch.update(_db.collection('users').doc(uid), {
        'followingCount': FieldValue.increment(-1),
        'following': FieldValue.arrayRemove([userId]),
      });
      batch.update(_db.collection('users').doc(userId), {
        'followerCount': FieldValue.increment(-1),
        'followers': FieldValue.arrayRemove([uid]),
      });
      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unfollow failed'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFollowers(
      String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      final ids = List<String>.from(doc.data()?['followers'] ?? []);
      final users = await _fetchUsersByIds(ids);
      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFollowing(
      String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      final ids = List<String>.from(doc.data()?['following'] ?? []);
      final users = await _fetchUsersByIds(ids);
      return Right(users);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final q = query.toLowerCase();
      final snap = await _db
          .collection('users')
          .orderBy('name')
          .startAt([q])
          .endAt(['$q'])
          .limit(20)
          .get();
      return Right(snap.docs.map(_userFromDoc).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Search failed'));
    }
  }

  Future<UserEntity> _fetchUserEntity(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return _userFromDoc(doc);
  }

  Future<List<UserEntity>> _fetchUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final snaps = await Future.wait(
      ids.map((id) => _db.collection('users').doc(id).get()),
    );
    return snaps.where((d) => d.exists).map(_userFromDoc).toList();
  }

  UserEntity _userFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final ts = d['createdAt'] as Timestamp?;
    return UserEntity(
      id: doc.id,
      name: d['name'] as String? ?? '',
      phone: d['phone'] as String? ?? '',
      wilayaId: d['wilayaId'] as String? ?? '',
      avatarUrl: d['avatarUrl'] as String? ?? '',
      reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
      followerCount: (d['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (d['followingCount'] as num?)?.toInt() ?? 0,
      jo3tPoints: (d['jo3tPoints'] as num?)?.toInt() ?? 0,
      createdAt: ts?.toDate() ?? DateTime.now(),
      bio: d['bio'] as String?,
    );
  }
}
