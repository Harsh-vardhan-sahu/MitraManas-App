import 'package:mitramanas/features.meditation/music/domain/entities/song.dart';

abstract class SongRepository{
 Future<List<Song>> getAllSongs();

}