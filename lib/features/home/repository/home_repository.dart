// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/failure/failure.dart';
import 'package:spotify_clone/features/home/models/song_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  final _client = Supabase.instance.client;

  /// Upload song & thumbnail and insert into DB
  Future<Either<AppFailure, String>> uploadAndSaveSong({
    required File song,
    required File image,
    required String songName,
    required String userId,
    required String artist,
    required String songId,
    String hexCode = '',
  }) async {
    final songPath = 'private/$songId/audio.mp3';
    final thumbPath = 'private/$songId/thumbnail.jpg';

    try {
      // Upload binary data (more reliable than raw File)
      await _client.storage
          .from('songs')
          .uploadBinary(songPath, await song.readAsBytes());

      await _client.storage
          .from('songs')
          .uploadBinary(thumbPath, await image.readAsBytes());

      // Create signed URLs (valid for 1 hour)
      final songUrl = await _client.storage
          .from('songs')
          .getPublicUrl(songPath);

      final thumbUrl = await _client.storage
          .from('songs')
          .getPublicUrl(thumbPath);

      // Insert into DB
      final response = await _client.from('songs').insert({
        'song_storage_id': songId,
        'title': songName,
        'artist': artist,
        'song_url': songUrl,
        'thumbnail_url': thumbUrl,
        'hex_code': hexCode,
        'user_id': userId,
      });

      if (response.error != null) {
        print('Insert failed: ${response.error!.message}');
      } else {
        print('🎵 Upload and metadata saved successfully');
      }

      return Right(response);
    } catch (e) {
      print('❌ Upload or insert failed: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs() async {
    try {
      final response = await Supabase.instance.client.from('songs').select();

      // Convert Supabase response to List<SongModel>
      final List<SongModel> songs =
          (response as List).map((json) => SongModel.fromMap(json)).toList();

      print('✅ Songs fetched: $songs');
      return Right(songs);
    } catch (e) {
      print('❌ Error: $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
