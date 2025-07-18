import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home_page/home_page.dart';
import 'auth_service.dart';
import 'google_signin_service.dart';
import 'sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() => _isLoading = false);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Sign-In Failed',
          desc: 'Invalid email or password. Please try again.',
          btnOkOnPress: () {},
          btnOkColor: Colors.blueAccent,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
          descTextStyle: GoogleFonts.poppins(color: Colors.grey[800]),
        ).show();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // light blue
              Color(0xFF81D4FA), // sky blue
              Color(0xFF0288D1), // vibrant blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeInDown(
                      child: Column(
                        children: [
                          Center(
                            child: Row(
                              children: [
                                const SizedBox(width: 45),
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                    'assets/img_7.png',
                                  ), // your image path
                                  backgroundColor:
                                      Colors.transparent, // no white background
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  'MitraManas',
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36 + 4),
                    FadeInUp(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Text(
                                    'Welcome Back!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),

                                FadeInLeft(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: const Icon(Icons.email),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelStyle: GoogleFonts.poppins(),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      );
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),

                                FadeInLeft(
                                  delay: const Duration(milliseconds: 200),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      labelStyle: GoogleFonts.poppins(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),

                                /// Login Button
                                FadeInUp(
                                  delay: const Duration(milliseconds: 400),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _signIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[800],
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Log In',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const SizedBox(height: 4),

                                /// OR Divider
                                FadeInUp(
                                  delay: const Duration(milliseconds: 500),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white70,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          'OR',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.white70,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                FadeInUp(
                                  delay: const Duration(milliseconds: 600),
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() => _isLoading = true);
                                      final user =
                                          await GoogleSignInService.signInWithGoogle();
                                      setState(() => _isLoading = false);

                                      if (user != null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => HomeScreen(),
                                          ),
                                        );
                                      } else {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          title: 'Google Sign-In Failed',
                                          desc: 'Please try again.',
                                          descTextStyle: TextStyle(
                                            color: Colors.black,
                                          ),
                                          btnOkOnPress: () {},
                                        ).show();
                                      }
                                    },

                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/google.png', // make sure this image exists
                                            height: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Sign in with Google',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// Sign Up Link
                                FadeInUp(
                                  delay: const Duration(milliseconds: 500),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Don\'t have an account? Sign Up',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
