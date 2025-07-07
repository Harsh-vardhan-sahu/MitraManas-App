import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mitramanas/features.meditation/music/domain/usecases/get_all_songs.dart';
import 'package:mitramanas/features.meditation/music/presentation/bloc/song_bloc.dart';
import 'package:mitramanas/features.meditation/music/presentation/bloc/song_event.dart';
import 'package:mitramanas/presentation/bottomNavbar/bloc/navigation_bloc.dart';
import 'package:mitramanas/splash.dart';

import 'features.meditation/music/data/datasources/song_remote_datasource.dart';
import 'features.meditation/music/data/repository/song_repository_impl.dart';
import 'features.meditation/presentation/pages/meditation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_)=>NavigationBloc(),),
          BlocProvider(create: (context)=>SongBloc(
              getAllSongs: GetAllSongs(
                  repository: SongRepositoryImpl(
                  remoteDataSource: SongRemoteDataSourceImpl(
                    client: http.Client()
                  ),
              )
              )
          )..add(FetchSongs())
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:SplashScreen(),
        ));

  }
}

