import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../features.meditation/Mitra/screen/chat_screen.dart';
import '../../features.meditation/meditation/presentation/pages/meditation.dart';
import '../../features.meditation/music/presentation/pages/music_player.dart';
import '../../features.meditation/music/presentation/pages/playlist_screen.dart';
import '../bottomNavbar/bloc/navigation_bloc.dart';
import '../bottomNavbar/bloc/navigation_event.dart';
import '../bottomNavbar/bloc/navigation_state.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Widget> pages = [
    MeditationScreen(),
    PlaylistScreen(),
    PlaylistScreen(),
  ];

  BottomNavigationBarItem createBottomNavItem({
    required String assetName,
    required String label,
    required bool isActive,
    required BuildContext context,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Image.asset(
              assetName,
              height: 28,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          if (isActive)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
      label: label,
      tooltip: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content

          BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              int index = 0;
              if (state is NavigationChanged) {
                index = state.index;
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: pages[index],
              );
            },
          ),
          // Gradient overlay for better visual hierarchy
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.background.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 330),
              pageBuilder: (context, animation, secondaryAnimation) => const ChatScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  alignment: Alignment.bottomRight,
                  scale: Tween<double>(begin: 0, end: 1)
                      .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                  child: child,
                );
              },
            ),
          );
        },
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            'assets/ai-technology.png',
            width: 32,
            height: 32,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              int currentIndex = 0;
              if (state is NavigationChanged) {
                currentIndex = state.index;
              }

              final List<BottomNavigationBarItem> bottomNavItems = [
                createBottomNavItem(
                  assetName: 'assets/menu_home.png',
                  label: 'Home',
                  isActive: currentIndex == 0,
                  context: context,
                ),
                createBottomNavItem(
                  assetName: 'assets/menu_songs.png',
                  label: 'Music',
                  isActive: currentIndex == 1,
                  context: context,
                ),
                createBottomNavItem(
                  assetName: 'assets/menu_teams.png',
                  label: 'Profile',
                  isActive: currentIndex == 2,
                  context: context,
                ),
              ];

              return BottomNavigationBar(
                items: bottomNavItems,
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavigationBloc>().add(NavigateTo(index: index));
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}