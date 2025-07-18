import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitraa/presentation/auth/sign_in.dart';
import 'package:mitraa/presentation/home_page/home_page.dart';

import '../../features/meditation/blog/Blog_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return  HomeScreen(); // ✅ user is logged in
        } else {
          return  SignInScreen(); // ❌ not logged in
        }
      },
    );
  }
}
