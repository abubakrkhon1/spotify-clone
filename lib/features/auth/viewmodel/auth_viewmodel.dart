import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/auth/services/auth_remote_service.dart';
import 'package:fpdart/fpdart.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteService _authRemoteService = AuthRemoteService();
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteService.signUp(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (response) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteService.signIn(
      email: email,
      password: password,
    );
    final val = switch (response) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
