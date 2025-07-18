import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../features/meditation/blog/streak_bar.dart';
import '../../../../presentation/home_page/drawer.dart';
import '../bloc/daily_quote/daily_quote_bloc.dart';
import '../bloc/daily_quote/daily_quote_state.dart';
import '../bloc/mood_message/mood_message_bloc.dart';
import '../bloc/mood_message/mood_message_event.dart';
import '../bloc/mood_message/mood_message_state.dart';
import '../widgets/Task_card.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String? userName;
  bool isLoading = true;
  bool isFeelingLoading = false;
  int currentStreak = 1; // ✅ Declare here (not inside any function)

  @override
  void initState() {
    super.initState();
    _checkAndUpdateStreak(); // Check and update streak on init
    fetchUserName();
  }

  Future<void> _checkAndUpdateStreak() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await userDocRef.get();

    if (!doc.exists) {
      await userDocRef.set({
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'Not provided',
        'streak': 0,
        'lastActive': null,
      });
    }

    final data = doc.data()!;
    final lastActive = (data['lastActive'] as Timestamp?)?.toDate();
    final streak = data['streak'] as int? ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    bool shouldUpdate = false;
    int newStreak = streak;

    if (lastActive == null) {
      // First activity ever
      newStreak = 1;
      shouldUpdate = true;
    } else {
      final last = DateTime(lastActive.year, lastActive.month, lastActive.day);
      if (last == today) {
        // Already active today; no update or message
      } else if (last == yesterday) {
        // Continue streak
        newStreak = streak + 1;
        shouldUpdate = true;
      } else {
        // Streak broken
        newStreak = 1;
        shouldUpdate = true;
      }
    }

    if (shouldUpdate) {
      await userDocRef.update({
        'streak': newStreak,
        'lastActive': FieldValue.serverTimestamp(),
      });

      _showStreakMessage(newStreak); // Show only once
      setState(() {
        currentStreak = newStreak;
      });
    } else {
      setState(() {
        currentStreak = streak;
      });
    }
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final name = doc['name'];
        setState(() {
          userName = name;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Guest';
        isLoading = false;
      });
    }
  }

  void _showStreakMessage(int streak) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.only(top: 280, left: 24, right: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FadeInDown(
                  child: Text(
                    '🔥 Your streak is now $streak day${streak > 1 ? 's' : ''}! Keep it going!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        const Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/menu_burger.png',
                width: 24,
                height: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Open Menu',
            );
          },
        ),
        actions: [
          FadeIn(
            child: CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage('assets/id.png'),
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: BlocListener<MoodMessageBloc, MoodMessageState>(
        listener: (context, state) {
          if (state is MoodMessageLoading) {
            setState(() => isFeelingLoading = true);
          } else {
            setState(() => isFeelingLoading = false);
          }

          if (state is MoodMessageLoaded) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.scale,
              title: 'Your Daily Inspiration',
              desc: state.moodMessage.text,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: DefaultColors.purple,
              ),
              descTextStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
              btnOk: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<MoodMessageBloc>().add(ResetMoodMessage());
                },
                child: const Text(
                  'Got It!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              dialogBackgroundColor: Colors.white,
              borderSide: const BorderSide(
                color: DefaultColors.lightteal,
                width: 2,
              ),
            ).show();
          } else if (state is MoodMessageError) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Oops!',
              desc: state.message,
              btnOkOnPress: () {},
              btnOkColor: DefaultColors.pink,
            ).show();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, DefaultColors.lightteal.withOpacity(0.15)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Text(
                      isLoading
                          ? 'Welcome...'
                          : 'Welcome, ${userName ?? 'Guest'}!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Weekly Streak,",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  // const SizedBox(height: 1),
                  if (!isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: StreakProgressBar(
                        currentStreak: currentStreak ?? 1,
                      ), // Replace 5 with your streak variable
                    ),

                  FadeInLeft(
                    child: Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[800],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isFeelingLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _buildFeelingButtons(context),
                        ),
                  const SizedBox(height: 24),
                  FadeInRight(
                    child: Text(
                      'Today\'s Quotes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[800],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<DailyQuoteBloc, DailyQuoteState>(
                    builder: (context, state) {
                      if (state is DailyQuoteLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DailyQuoteLoaded) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                          child: Column(
                            children: [
                              FadeInUp(
                                child: TaskCard(
                                  title: 'Morning',
                                  description: state.dailyQuote.morningQuote,
                                  color: DefaultColors.task1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FadeInUp(
                                delay: const Duration(milliseconds: 200),
                                child: TaskCard(
                                  title: 'Noon',
                                  description: state.dailyQuote.noonQuote,
                                  color: DefaultColors.task2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FadeInUp(
                                delay: const Duration(milliseconds: 400),
                                child: TaskCard(
                                  title: 'Evening',
                                  description: state.dailyQuote.eveningQuote,
                                  color: DefaultColors.task3,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is DailyQuoteError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No data found',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeelingButtons(BuildContext context) {
    final List<Map<String, dynamic>> feelings = [
      {
        'label': 'Happy',
        'image': 'assets/icons50.png',
        'gradient': [DefaultColors.pink, DefaultColors.pink.withOpacity(0.7)],
        'mood': 'Today I am happy',
      },
      {
        'label': 'Calm',
        'image': 'assets/yin-yang.png',
        'gradient': [
          DefaultColors.purple,
          DefaultColors.purple.withOpacity(0.7),
        ],
        'mood': 'Today I am calm',
      },
      {
        'label': 'Relax',
        'image': 'assets/relax.png',
        'gradient': [
          DefaultColors.orange,
          DefaultColors.orange.withOpacity(0.7),
        ],
        'mood': 'Today I am relax',
      },
      {
        'label': 'Focus',
        'image': 'assets/focus.png',
        'gradient': [
          DefaultColors.lightteal,
          DefaultColors.lightteal.withOpacity(0.7),
        ],
        'mood': 'Today I need to be focus but feel like I am missing something',
      },
    ];

    return feelings
        .map(
          (item) => AdvancedFeelingButton(
            label: item['label'] as String,
            image: item['image'] as String,
            gradient: LinearGradient(colors: item['gradient'] as List<Color>),
            onTap: () => context.read<MoodMessageBloc>().add(
              FetchMoodMessage(item['mood'] as String),
            ),
          ),
        )
        .toList();
  }
}

class AdvancedFeelingButton extends StatefulWidget {
  final String label;
  final String image;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const AdvancedFeelingButton({
    Key? key,
    required this.label,
    required this.image,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  _AdvancedFeelingButtonState createState() => _AdvancedFeelingButtonState();
}

class _AdvancedFeelingButtonState extends State<AdvancedFeelingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.value = 1.0; // Ensure initialized to full scale
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 81,
          height: 87,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glassmorphism layer
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(widget.image, width: 36, height: 36),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
