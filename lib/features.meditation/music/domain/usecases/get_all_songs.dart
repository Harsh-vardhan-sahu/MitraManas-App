import 'package:mitramanas/features.meditation/music/domain/repository/song_repository.dart';

import '../entities/song.dart';

class GetAllSongs{
  final SongRepository repository;

  GetAllSongs({required this.repository});

  Future<List<Song>> call()async{
  return await repository.getAllSongs();
}}