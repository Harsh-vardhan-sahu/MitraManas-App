import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';



import '../presentation/home_page/home_page.dart';

class HelpMeScreen extends StatelessWidget {
  const HelpMeScreen({super.key});
  void _call(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(telUri, mode: LaunchMode.externalApplication)) {
      debugPrint("❌ Could not launch dialer for $number");
    }
  }


  @override
  Widget build(BuildContext context) {
    final contacts = [
      {
        'name': 'iCall (TISS)',
        'phone': '+919152987821',
        'desc': 'Free mental health support by trained professionals.'
      },
      {
        'name': 'Vandrevala Foundation',
        'phone': '18602662345',
        'desc': '24x7 support for mental health issues.'
      },
      {
        'name': 'AASRA',
        'phone': '+919820466726',
        'desc': 'Suicide prevention & emotional support.'
      },
      {
        'name': 'Snehi',
        'phone': '+919582208181',
        'desc': 'Youth and adolescent mental health helpline.'
      },
      {
        'name': 'Fortis Stress Helpline',
        'phone': '+918376804102',
        'desc': 'Talk to mental health professionals.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>HomeScreen()),
          )
        ),
        title: Center(
          child: Text(
            'Emergency Support',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        actions: const [SizedBox(width: 48)], // To balance the centered title
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Text(
                'Need Help?',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'These verified helplines are available 24x7. Reach out without hesitation.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: contacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact['desc']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => _call(contact['phone']!),
                              icon: const Icon(Icons.call, size: 18),
                              label: Text(
                                'Call Now',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
