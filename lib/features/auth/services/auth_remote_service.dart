import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_remote_service.g.dart';

@riverpod
AuthRemoteService authRemoteService(AuthRemoteServiceRef ref){
  return AuthRemoteService();
}

class AuthRemoteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        return Left(AppFailure('No user'));
      }

      final user = response.user;
      if (user == null) {
        return Left(AppFailure('No user found'));
      }

      return Right(UserModel(email: user.email!, id: user.id));
    } on AuthException catch (e) {
      // Supabase-specific error
      return Left(AppFailure(e.message));
      // Show to user
    } catch (e) {
      // Generic error
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return Left(AppFailure('No user found'));
      }

      return Right(UserModel(email: user.email!, id: user.id));
    } on AuthApiException catch (e) {
      return Left(AppFailure(e.message));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
