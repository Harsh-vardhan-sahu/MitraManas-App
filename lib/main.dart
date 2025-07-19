import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mitraa/presentation/auth/authwrapper.dart';
import 'package:mitraa/presentation/bottomNavbar/bloc/navigation_bloc.dart';

import 'core/theme.dart';
import 'features.meditation/meditation/presentation/bloc/daily_quote/daily_quote_bloc.dart';
import 'features.meditation/meditation/presentation/bloc/daily_quote/daily_quote_event.dart';
import 'features.meditation/meditation/presentation/bloc/mood_message/mood_message_bloc.dart';
import 'features.meditation/music/presentation/bloc/song_bloc.dart';
import 'features.meditation/music/presentation/bloc/song_event.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If you're using .env, make sure the file exists and has values
  //await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("✅ Firebase initialized successfully");
  await dotenv.load();
  await Hive.initFlutter();
  await Hive.openBox('chatBox');
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (context) => di.sl<SongBloc>()..add(FetchSongs())),
        BlocProvider(
          create: (context) => di.sl<DailyQuoteBloc>()..add(FetchDailyQuote()),
        ),
        BlocProvider(create: (context) => di.sl<MoodMessageBloc>()),
      ],
      child: MaterialApp(
        title: 'MitraManas',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
