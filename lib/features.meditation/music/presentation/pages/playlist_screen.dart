import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../bloc/song_bloc.dart';
import '../bloc/song_state.dart';
import 'music_player.dart';

class PlaylistScreen extends StatefulWidget {

  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'chill Playlist',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: DefaultColors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: BlocBuilder<SongBloc, SongState>(
        builder: (context, state) {
          if (state is SongLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SongLoaded) {
            return Container(
              color: DefaultColors.white,
              child: ListView.builder(
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  final song = state.songs[index];
                  return ListTile(
                     leading: CircleAvatar(
                    radius: 25, // adjust size as needed
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(
                      (song.image?.isNotEmpty ?? false)
                          ? song.image!
                          : 'https://picsum.photos/200',
                    ),
                    onBackgroundImageError: (_, __) {
                      print("Image load failed for: ${song.image}");
                    },
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                    title: Text(
                      song.title,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    subtitle: Text(
                      song.artist,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPlayerScreen(song: state.songs[index],),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is SongError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          } else {
            return Center(
              child: Text(
                'No Songs found',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            );
          }
        },
      ),
    );
  }
}
