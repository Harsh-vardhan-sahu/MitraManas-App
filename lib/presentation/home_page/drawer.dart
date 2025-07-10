import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features.meditation/meditation/presentation/pages/meditation.dart';
import '../../features.meditation/music/presentation/pages/playlist_screen.dart';

class CustomDrawer extends StatelessWidget {
const CustomDrawer({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return Drawer(
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
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

Widget _buildHeader(BuildContext context) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Theme.of(context).colorScheme.primary.withOpacity(0.3),
Theme.of(context).colorScheme.secondary.withOpacity(0.3),
],
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
CircleAvatar(
radius: 40,
backgroundColor: Theme.of(context).colorScheme.primary,
child: Image.asset(
'assets/user_profile.png',
width: 48,
height: 48,
color: Theme.of(context).colorScheme.onPrimary,
errorBuilder: (context, error, stackTrace) => Icon(
Icons.person,
size: 48,
color: Theme.of(context).colorScheme.onPrimary,
),
),
),
const SizedBox(height: 16),
Text(
'Welcome Back!',
style: Theme.of(context).textTheme.headlineSmall?.copyWith(
fontWeight: FontWeight.bold,
color: Theme.of(context).colorScheme.onSurface,
),
),
const SizedBox(height: 4),
Text(
'User Name',
style: Theme.of(context).textTheme.bodyLarge?.copyWith(
color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
),
),
],
),
);
}

Widget _buildMenuItems(BuildContext context) {
return ListView(
padding: EdgeInsets.zero,
children: [
_buildDrawerItem(
context: context,
icon: 'assets/menu_home.png',
title: 'Home',
onTap: () {
Navigator.pop(context);
Get.to(() => MeditationScreen());
},
),
_buildDrawerItem(
context: context,
icon: 'assets/menu_songs.png',
title: 'Music',
onTap: () {
Navigator.pop(context);
Get.to(() => PlaylistScreen());
},
),
_buildDrawerItem(
context: context,
icon: 'assets/menu_teams.png',
title: 'Teams',
onTap: () {
Navigator.pop(context);
Get.to(() => PlaylistScreen());
},
),
const Divider(indent: 16, endIndent: 16, thickness: 1),
_buildDrawerItem(
context: context,
icon: 'assets/settings.png',
title: 'Settings',
onTap: () {
Navigator.pop(context);
// Navigate to settings screen
},
),
_buildDrawerItem(
context: context,
icon: 'assets/logout.png',
title: 'Logout',
onTap: () {
Navigator.pop(context);
// Handle logout
},
),
],
);
}

Widget _buildFooter(BuildContext context) {
return Padding(
padding: const EdgeInsets.all(16),
child: Row(
children: [
Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
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
required VoidCallback onTap,
}) {
return ListTile(
contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
leading: Image.asset(
icon,
width: 24,
height: 24,
color: Theme.of(context).colorScheme.primary,
errorBuilder: (context, error, stackTrace) => Icon(
Icons.error_outline,
size: 24,
color: Theme.of(context).colorScheme.error,
),
),
title: Text(
title,
style: Theme.of(context).textTheme.bodyLarge?.copyWith(
fontWeight: FontWeight.w600,
color: Theme.of(context).colorScheme.onSurface,
),
),
onTap: onTap,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
tileColor: Colors.transparent,
hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
);
}
}
