import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitraa/presentation/auth/sign_in.dart';
import 'home_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showSignOutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Sign Out',
      desc: 'Are you sure you want to sign out?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        }
      },
      btnOkText: 'Sign Out',
      btnCancelText: 'Cancel',
      btnOkColor: Colors.deepPurple,
      btnCancelColor: Colors.grey,
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      descTextStyle: GoogleFonts.poppins(color: Colors.black45),
    ).show();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'Not provided',
        'streak': 1,
        'lastActive': null,
      });
      return {
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'Not provided',
        'streak': 1,
        'lastActive': null,
      };
    }

    final data = doc.data()!;
    if (!data.containsKey('streak')) {
      await docRef.update({'streak': 1, 'lastActive': FieldValue.serverTimestamp()});
      data['streak'] = 1;
      data['lastActive'] = DateTime.now();
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF1E88E5),
              Color(0xFF2196F3),
              Color(0xFF1A237E),
              Color(0xFF311B92),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              final data = snapshot.data;
              if (data == null) {
                return const Center(
                  child: Text("No profile data found.", style: TextStyle(color: Colors.white)),
                );
              }

              final name = data['name'] ?? 'Unknown';
              final email = data['email'] ?? 'Not provided';
              final streak = data['streak']?.toString() ?? '0';

              // Monthly streak logic:
              final now = DateTime.now();
              final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
              final parsedStreak = int.tryParse(streak) ?? 0;
              final normalizedStreak = parsedStreak > daysInMonth ? daysInMonth : parsedStreak;
              final progress = normalizedStreak / daysInMonth;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            FadeInDown(
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '          Profile',
                                      style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Avatar & Name
                            FadeInLeft(
                              duration: const Duration(milliseconds: 500),
                              child: _glassCard(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 47,
                                      backgroundImage: const AssetImage('assets/id.png'),
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Mindful Explorer',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email Tile
                            FadeInLeft(
                              duration: const Duration(milliseconds: 600),
                              child: _glassTile(Icons.email_rounded, 'Email', email),
                            ),
                            const SizedBox(height: 14),

                            // Streak Tile
                            FadeInLeft(
                              duration: const Duration(milliseconds: 700),
                              child: _glassTile(Icons.local_fire_department_rounded, 'Streak', '$streak days'),
                            ),
                            const SizedBox(height: 14),

                            // Progress Bar
                            FadeInLeft(
                              duration: const Duration(milliseconds: 800),
                              child: _glassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monthly Streak Progress',
                                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                                      minHeight: 8,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$normalizedStreak / $daysInMonth days',
                                      style: GoogleFonts.poppins(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Sign Out Button
                            FadeInUp(
                              duration: const Duration(milliseconds: 900),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _showSignOutDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8E24AA),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Out',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _glassTile(IconData icon, String title, String value) {
    return _glassCard(
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
