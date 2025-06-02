import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone/core/utils.dart';
import 'package:spotify_clone/features/home/repository/home_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:spotify_clone/features/home/models/song_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final response = await ref.watch(homeRepositoryProvider).getAllSongs();

  return switch (response) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;

  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final userId = Supabase.instance.client.auth.currentUser?.id;
    final String songId = const Uuid().v4();

    final res = await _homeRepository.uploadAndSaveSong(
      song: selectedAudio,
      image: selectedThumbnail,
      songName: songName,
      songId: songId,
      userId: userId!,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
