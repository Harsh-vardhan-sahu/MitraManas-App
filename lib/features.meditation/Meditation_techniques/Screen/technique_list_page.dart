import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mitraa/presentation/home_page/home_page.dart';

import '../Model/meditation_technique_model.dart';
import '../Service/technique_api_service.dart';
import 'GlassDialogContent.dart';

class TechniqueListPage extends StatefulWidget {
  const TechniqueListPage({Key? key}) : super(key: key);

  @override
  State<TechniqueListPage> createState() => _TechniqueListPageState();
}

class _TechniqueListPageState extends State<TechniqueListPage> {
  late Future<List<MeditationTechnique>> _techniquesFuture;

  @override
  void initState() {
    super.initState();
    _techniquesFuture = TechniqueApiService().fetchTechniques();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        return false; // Prevent default back (pop)
      },

      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Row(

            children: [

              const Text('Meditation Techniques',style:TextStyle(color: Colors.white),),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF001D3D), // deep navy
                    Color(0xFF003566), // ocean blue
                    Color(0xFF00A6FB), // light star blue
                  ],
                ),
              ),
            ),
      
      
      
            FutureBuilder<List<MeditationTechnique>>(
      
              future: _techniquesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                }
      
                final techniques = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(top: kToolbarHeight + 22, bottom: 16),
                  itemCount: techniques.length,
                  itemBuilder: (context, index) {
                    final technique = techniques[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 400 + index * 100),
                      child: GlassCard(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              technique.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            technique.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            technique.description.length > 80
                                ? '${technique.description.substring(0, 80)}...'
                                : technique.description,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return Center(
                                  child: AnimatedOpacity(
                                    opacity: 1,
                                    duration: const Duration(milliseconds: 300),
                                    child: Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                                      child: GlassDialogContent(technique: technique),
                                    ),
                                  ),
                                );
                              },
                            );
                          //  await FlutterTts().stop();
                          },
      
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsets margin;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.2,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
