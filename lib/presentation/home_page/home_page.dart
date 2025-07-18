import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mitraa/presentation/home_page/profile%20page.dart';
import '../../features.meditation/Mitra/screen/chat_screen.dart';
import '../../features.meditation/blog/Blog_page.dart';
import '../../features.meditation/meditation/presentation/pages/meditation.dart';
import '../../features.meditation/music/presentation/pages/music_player.dart';
import '../../features.meditation/music/presentation/pages/playlist_screen.dart';
import '../bottomNavbar/bloc/navigation_bloc.dart';
import '../bottomNavbar/bloc/navigation_event.dart';
import '../bottomNavbar/bloc/navigation_state.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const List<Widget> pages = [
    MeditationScreen(),
    PlaylistScreen(),
    BlogListScreen(),
    ProfileScreen()
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(assetName: 'assets/home.png', label: 'Home', semanticLabel: 'Home Screen'),
    _NavItem(assetName: 'assets/playlist.png', label: 'PlayList', semanticLabel: 'Music Playlist'),
    _NavItem(assetName: 'assets/group.png', label: 'Community Blogs', semanticLabel: 'Blog'),
    _NavItem(assetName: 'assets/user.png', label: 'Profile', semanticLabel: 'User Profile'),
  ];

  BottomNavigationBarItem _createBottomNavItem({
    required _NavItem navItem,
    required bool isActive,
    required BuildContext context,
  }) {
    return BottomNavigationBarItem(
      icon: _NavIcon(assetName: navItem.assetName, isActive: isActive, context: context),
      label: navItem.label,
      tooltip: navItem.semanticLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true, // extends body behind bottom nav
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFADD8E6), // light blue
                  Color(0xFF87CEFA), // sky blue
                  Color(0xFF6495ED), // cornflower blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),


          BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              int index = 0;
              if (state is NavigationChanged) index = state.index;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: pages[index],
              );
            },
          ),

          // 🔲 Optional: Bottom Gradient Fade-In
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black12,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, anim, __) => const ChatScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutBack,
                      );
                      return FadeTransition(
                        opacity: curved,
                        child: ScaleTransition(
                          scale: curved,
                          alignment: Alignment.bottomRight,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
              child: Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(33),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D5DF6), Color(0xFF8E72F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/ai-technology.png',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // 🔻 Bottom Nav
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}


// Model for navigation items
class _NavItem {
  final String assetName;
  final String label;
  final String semanticLabel;

  const _NavItem({
    required this.assetName,
    required this.label,
    required this.semanticLabel,
  });
}

// Custom widget for navigation icons with animation
class _NavIcon extends StatelessWidget {
  final String assetName;
  final bool isActive;
  final BuildContext context;

  const _NavIcon({
    required this.assetName,
    required this.isActive,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetName,
            height: 26,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 30 : 0,
            height: 2,
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
            curve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.only( right: 0), // spacing
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // glassy white
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                int currentIndex = 0;
                if (state is NavigationChanged) {
                  currentIndex = state.index;
                }

                return BottomNavigationBar(
                  items: HomeScreen._navItems
                      .asMap()
                      .entries
                      .map((entry) => HomeScreen()._createBottomNavItem(
                    navItem: entry.value,
                    isActive: currentIndex == entry.key,
                    context: context,
                  ))
                      .toList(),
                  currentIndex: currentIndex,
                  onTap: (index) {
                    context.read<NavigationBloc>().add(NavigateTo(index: index));
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.5,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
