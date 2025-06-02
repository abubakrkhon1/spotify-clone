// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class SongModel {
  final String id;
  final String title;
  final String song_url;
  final String thumbnail_url;
  final String song_storage_id;
  final String artist;
  final String hex_code;

  const SongModel({
    required this.id,
    required this.title,
    required this.song_url,
    required this.thumbnail_url,
    required this.song_storage_id,
    required this.artist,
    required this.hex_code,
  });

  SongModel copyWith({
    String? id,
    String? title,
    String? song_url,
    String? thumbnail_url,
    String? song_storage_id,
    String? artist,
    String? hex_code,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      song_storage_id: song_storage_id ?? this.song_storage_id,
      artist: artist ?? this.artist,
      hex_code: hex_code ?? this.hex_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'song_storage_id': song_storage_id,
      'artist': artist,
      'hex_code': hex_code,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'].toString(),
      title: map['title']?.toString() ?? '',
      song_url: map['song_url']?.toString() ?? '',
      thumbnail_url: map['thumbnail_url']?.toString() ?? '',
      song_storage_id: map['song_storage_id']?.toString() ?? '',
      artist: map['artist']?.toString() ?? '',
      hex_code: map['hex_code']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, song_url: $song_url, thumbnail_url: $thumbnail_url, song_storage_id: $song_storage_id, artist: $artist, hex_code: $hex_code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SongModel &&
        other.id == id &&
        other.title == title &&
        other.song_url == song_url &&
        other.thumbnail_url == thumbnail_url &&
        other.song_storage_id == song_storage_id &&
        other.artist == artist &&
        other.hex_code == hex_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        song_url.hashCode ^
        thumbnail_url.hashCode ^
        song_storage_id.hashCode ^
        artist.hashCode ^
        hex_code.hashCode;
  }
}
