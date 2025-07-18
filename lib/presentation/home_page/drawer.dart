import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mitraa/presentation/home_page/profile%20page.dart';

// Screens
import '../../drawer_screens/help_me.dart';
import '../../drawer_screens/policy.dart';
import '../../features.meditation/Meditation_techniques/Screen/technique_list_page.dart';
import '../../features.meditation/meditation/presentation/pages/meditation.dart';
import '../../features.meditation/music/presentation/pages/playlist_screen.dart';
import '../auth/sign_in.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});


  static Future<String> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        return doc['name'] ?? 'Friend';
      }
    } catch (e) {
      debugPrint('Error fetching username: $e');
    }
    return 'Friend';
  }

  void _showSignOutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Sign Out',
      desc: 'Are you sure you want to sign out?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (_) => false,
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error signing out: $e')),
            );
          }
        }
      },
      btnOkText: 'Sign Out',
      btnCancelText: 'Cancel',
      btnOkColor: Theme.of(context).colorScheme.error,
      btnCancelColor: Theme.of(context).colorScheme.secondary,
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      descTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildMenuItems(context)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // 🔹 Drawer header with profile + name
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.4),
            Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(24),
        ),
      ),
      child: FutureBuilder<String>(
        future: fetchUserName(),
        builder: (context, snapshot) {
          final userName = snapshot.data ?? 'Friend';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: const AssetImage('assets/id.png'),
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                  children: [
                    TextSpan(
                      text: userName ?? 'Guest',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildDrawerItem(
          context: context,
          icon: 'assets/user.png',
          title: 'Profile',
          semanticLabel: 'Navigate to Home',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ProfileScreen()),
            );
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: 'assets/playlist.png',
          title: 'Peaceful Playlist',
          semanticLabel: 'Navigate to Music',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlaylistScreen()),
            );
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: 'assets/icons8.png',
          title: 'Meditation Techniques',
          semanticLabel: 'Navigate to Music',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TechniqueListPage()),
            );
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: 'assets/handshake.png',
          title: 'Help Me',
          semanticLabel: 'Navigate to Teams',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpMeScreen()),
            );
          },
        ),
        const Divider(indent: 16, endIndent: 16, thickness: 1),
        _buildDrawerItem(
          context: context,
          icon: 'assets/file.png',
          title: 'Privacy Policy',
          semanticLabel: 'View Privacy Policy',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            );
          },
        ),
        _buildDrawerItem(
          context: context,
          icon: 'assets/logout.png',
          title: 'Sign Out',
          semanticLabel: 'Sign out of the app',
          onTap: () => _showSignOutDialog(context),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String icon,
    required String title,
    required String semanticLabel,
    required VoidCallback onTap,
  }) {
    final isSignOut = title == 'Sign Out';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Image.asset(
        icon,
        width: 24,
        height: 24,
        color: isSignOut
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        errorBuilder: (_, __, ___) => Icon(
          Icons.error_outline,
          size: 24,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isSignOut
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}
