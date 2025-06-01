// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/providers/current_user_notifier.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:spotify_clone/features/auth/services/auth_remote_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  AuthRemoteService get _authRemoteService =>
      ref.read(authRemoteServiceProvider);

  @override
  AsyncValue<UserModel?> build() {
    return const AsyncValue.data(null);
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
      Right(value: final r) => state = _setUser(r, state),
    };
  }

  Future<void> signOut() async {
    state = AsyncValue.loading();
    await _authRemoteService.signOut();
    ref.read(currentUserNotifierProvider.notifier).clearUser();
    state = const AsyncValue.data(null);
  }

  AsyncValue<UserModel> _setUser(UserModel user, state) {
    final userState = ref
        .read(currentUserNotifierProvider.notifier)
        .addUser(user);
    return AsyncValue.data(user);
  }

  Future checkSession() async {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser != null) {
      final userModel = UserModel(
        id: currentUser.id,
        email: currentUser.email!,
        name: 'Placeholder Name',
      );
      state = AsyncValue.data(userModel);
    } else {
      state = AsyncValue.data(null);
    }
  }
}
