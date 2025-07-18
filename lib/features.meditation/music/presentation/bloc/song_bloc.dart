

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mitraa/features.meditation/music/presentation/bloc/song_event.dart';
import 'package:mitraa/features.meditation/music/presentation/bloc/song_state.dart';

import '../../domain/usecases/get_all_songs.dart';

class SongBloc extends Bloc<SongEvent, SongState>{
   final GetAllSongs getAllSongs;

   SongBloc({required this.getAllSongs}) : super(SongInitial()){
     on<FetchSongs>((event,emit) async{
       emit(SongLoading());
       try{
         final songs = await getAllSongs();
         emit(SongLoaded(songs: songs));
       }catch(e) {
         emit(SongError(message: e.toString()));
       }
     });
   }
}