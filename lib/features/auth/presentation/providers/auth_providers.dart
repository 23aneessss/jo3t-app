import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => MockAuthRepository(),
);

// Current authenticated user
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  final result = await repo.getCurrentUser();
  return result.fold((_) => null, (user) => user);
});

// Auth state notifier — handles sign in/out flows
class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final result = await repo.getCurrentUser();
    return result.fold((_) => null, (user) => user);
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signInWithGoogle();
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncData(user);
        return true;
      },
    );
  }

  Future<String?> sendOtp(String phone) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.sendOtp(phone);
    return result.fold((_) => null, (id) => id);
  }

  Future<bool> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.verifyOtp(
        verificationId: verificationId, otp: otp);
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncData(user);
        return true;
      },
    );
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncData(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);

// Is the user authenticated?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );
});

// Follow state notifier
class FollowNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  Future<void> toggle(String userId) async {
    final repo = ref.read(authRepositoryProvider);
    if (state.contains(userId)) {
      await repo.unfollowUser(userId);
      state = {...state}..remove(userId);
    } else {
      await repo.followUser(userId);
      state = {...state, userId};
    }
  }

  bool isFollowing(String userId) => state.contains(userId);
}

final followNotifierProvider =
    NotifierProvider<FollowNotifier, Set<String>>(FollowNotifier.new);
