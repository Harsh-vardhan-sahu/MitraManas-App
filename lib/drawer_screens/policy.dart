import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../presentation/home_page/home_page.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),

        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>HomeScreen()),
            )
        ),
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FadeInUp(
          duration: const Duration(milliseconds: 500),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Privacy Matters",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Mitra Manas is committed to protecting your privacy and ensuring the security of your data. This privacy policy outlines how we collect, use, and safeguard your information when using the app.",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _sectionTitle("1. Data Collection"),
                      _sectionContent(
                        "We collect basic information like your name, email address, and mood entries for a personalized experience. We never collect sensitive personal data without your consent.",
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle("2. Usage of Data"),
                      _sectionContent(
                        "Your data is used to improve the services of the app, such as suggesting better quotes or advice. None of your data is shared with third parties for marketing.",
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle("3. Security"),
                      _sectionContent(
                        "We use Firebase Authentication, Firestore, and encrypted local storage (Hive) to protect your data. All communication is secured with HTTPS protocols.",
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle("4. Community Blogs & Assistant"),
                      _sectionContent(
                        "Posts made in the blog section are public. Please avoid sharing personal identifiable information. Our assistant may store anonymous usage logs to improve responses.",
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle("5. Your Control"),
                      _sectionContent(
                        "You can delete your account and associated data at any time by going to the settings page and requesting deletion.",
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle("6. Contact Us"),
                      _sectionContent(
                        "For any privacy-related concerns, feel free to reach out to us at: support@mitramanas.in",
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          "Last updated: July 13, 2025",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }
}
