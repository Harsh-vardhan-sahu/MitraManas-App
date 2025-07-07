import '../../domain/entities/song.dart';

class SongModel extends Song {
  SongModel({
    required int id,
    required String title,
    required String artist,
    required String link,
  }) : super(id: id, title: title, artist: artist, link: link);

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      link: json['link'],
    );
  }
}
