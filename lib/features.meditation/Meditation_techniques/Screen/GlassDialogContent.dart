import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


import '../Model/meditation_technique_model.dart';

class GlassDialogContent extends StatefulWidget {
  final MeditationTechnique technique;

  const GlassDialogContent({super.key, required this.technique});

  @override
  State<GlassDialogContent> createState() => _GlassDialogContentState();
}

class _GlassDialogContentState extends State<GlassDialogContent> {
  final FlutterTts flutterTts = FlutterTts();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _speakTechnique();
  }

  Future<void> _speakTechnique() async {
    if (isMuted) return;
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak("${widget.technique.title}. ${widget.technique.description}");
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    if (isMuted) {
      flutterTts.stop();
    } else {
      _speakTechnique();
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Ensure TTS stops when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await flutterTts.stop(); // Stop voice on back/close
        return true;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🌌 Image + Mute Button
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.technique.imageUrl,
                          fit: BoxFit.cover,
                          height: 180,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: InkWell(
                          onTap: _toggleMute,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.technique.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.technique.description,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        flutterTts.stop(); // Ensure voice stops
                        Navigator.pop(context); // Close the dialog
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
