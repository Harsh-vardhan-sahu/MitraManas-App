import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme.dart';
import '../../domain/entities/song.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Song song;
  const MusicPlayerScreen({super.key, required this.song});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isLooping = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.song.link);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seekBackward() {
    final currentPosition = _audioPlayer.position;
    final newPosition = currentPosition - Duration(seconds: 10);
    _audioPlayer.seek(newPosition >= Duration.zero ? newPosition : Duration.zero);
  }

  void seekForward() {
    final currentPosition = _audioPlayer.position;
    final newPosition = currentPosition + Duration(seconds: 10);
    _audioPlayer.seek(newPosition);
  }

  void toggleLoop() {
    setState(() {
      isLooping = !isLooping;
      _audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFADD8E6),
        elevation: 0,
        leading: GestureDetector(
          child: Image.asset('assets/down_arrow.png'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),

      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFADD8E6),  // light blue
              Color(0xFF87CEFA),  // sky blue
              Color(0xFF6495ED),  // cornflower blue
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                (widget.song.image?.isNotEmpty ?? false)
                    ? widget.song.image!
                    : 'https://picsum.photos/400',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Failed to load song image: ${widget.song.image}");
                  return Image.asset(
                    'assets/child_with_dog.png', // fallback local image
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(color: DefaultColors.pink),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.song.title, style: Theme.of(context).textTheme.labelLarge),
            Text(widget.song.artist, style: Theme.of(context).textTheme.labelSmall),
            const Spacer(),
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total = _audioPlayer.duration ?? Duration.zero;
                return ProgressBar(
                  progress: position,
                  total: total,
                  onSeek: (duration) {
                    _audioPlayer.seek(duration);
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shuffle, color: DefaultColors.pink),
                ),
                IconButton(
                  onPressed: seekBackward,
                  icon: Icon(Icons.skip_previous, color: DefaultColors.pink),
                ),
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState ?? ProcessingState.idle;
                    final playing = playerState?.playing ?? false;

                    if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 50.0,
                        height: 50.0,
                        child: const CircularProgressIndicator(color: DefaultColors.pink),
                      );
                    } else if (!playing) {
                      return IconButton(
                        iconSize: 80,
                        onPressed: togglePlayPause,
                        icon: const Icon(Icons.play_circle, color: DefaultColors.pink),
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        iconSize: 80,
                        onPressed: togglePlayPause,
                        icon: const Icon(Icons.pause_circle, color: DefaultColors.pink),
                      );
                    } else {
                      return IconButton(
                        iconSize: 80,
                        onPressed: () => _audioPlayer.seek(Duration.zero),
                        icon: const Icon(Icons.replay_circle_filled, color: DefaultColors.pink),
                      );
                    }
                  },
                ),
                IconButton(
                  onPressed: seekForward,
                  icon: Icon(Icons.skip_next, color: DefaultColors.pink),
                ),
                IconButton(
                  onPressed: toggleLoop,
                  icon: Icon(
                    isLooping ? Icons.repeat_one : Icons.repeat,
                    color: DefaultColors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
