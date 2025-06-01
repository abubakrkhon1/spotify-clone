// ignore_for_file: unused_local_variable

import 'package:fpdart/fpdart.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/features/auth/model/user_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_remote_service.g.dart';

@riverpod
AuthRemoteService authRemoteService(Ref ref) {
  return AuthRemoteService();
}

class AuthRemoteService {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      final user = response.user;
      if (user == null) {
        return Left(AppFailure('No user found'));
      }

      final List profile =
          await supabaseClient.from('users').insert({
            'id': user.id,
            'name': name,
            'email': email,
          }).select();

      if (profile.isEmpty) {
        return Left(AppFailure('Profile creation failed'));
      }

      return Right(UserModel(email: user.email!, id: user.id, name: name));
    } on AuthException catch (e) {
      return Left(AppFailure(e.message));
    } catch (e) {
      print(e.toString());
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return Left(AppFailure('No user found'));
      }
      final List profile = await supabaseClient.from('users').select('name');

      if (profile.isEmpty) {
        return Left(AppFailure('Profile was not found!'));
      }

      return Right(
        UserModel(email: user.email!, id: user.id, name: profile[0]['name']),
      );
    } on AuthApiException catch (e) {
      return Left(AppFailure(e.message));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future signOut() async {
    try {
      final response = await supabaseClient.auth.signOut();
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
