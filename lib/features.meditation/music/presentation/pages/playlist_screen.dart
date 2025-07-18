import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart'; // For animations

import '../../../../core/theme.dart';
import '../../../../presentation/home_page/home_page.dart';
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent to show gradient
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF87CEFA),// Deeper light blue
                Color(0xFFADD8E6),
                Color(0xFF87CEFA),// Deeper light blue
                Color(0xFF6495ED)
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Peaceful Playlist',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SongBloc, SongState>(
                    builder: (context, state) {
                      if (state is SongLoading) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (state is SongLoaded) {
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 70),
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            final song = state.songs[index];
                            // Alternating animation direction
                            final isEven = index % 2 == 0;
                            return FadeIn(
                              duration: const Duration(milliseconds: 600),
                              delay: Duration(milliseconds: index * 100),
                           //   curve: isEven ? 20 : -20, // Fade from up or down
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MusicPlayerScreen(song: song),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.15), // Glassy effect
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      backgroundBlendMode: BlendMode.overlay, // Enhances glassy effect
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      leading: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.white.withOpacity(0.2),
                                        backgroundImage: NetworkImage(
                                          (song.image?.isNotEmpty ?? false)
                                              ? song.image!
                                              : 'https://picsum.photos/200',
                                        ),
                                        onBackgroundImageError: (_, __) {
                                          debugPrint("Image load failed for: ${song.image}");
                                        },
                                      ),
                                      title: Text(
                                        song.title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        song.artist,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.play_arrow,
                                        size: 28,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is SongError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No Songs found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}