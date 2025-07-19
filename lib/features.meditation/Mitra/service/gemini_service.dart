import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static List<String> get _apiKeys {
    final keysString = dotenv.env['GEMINI_API_KEYS'] ?? '';
    return keysString.isEmpty ? [] : keysString.split(',');
  }

  static Future<String> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        return doc.data()?['name'] as String? ?? 'Friend';
      }
      return 'Friend';
    } catch (e) {
      debugPrint("Error fetching user name: $e");
      return 'Friend';
    }
  }

  static Future<String> sendMessage(String prompt) async {
    String name = await fetchUserName();
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first_time_user') ?? true;

    if (isFirstTime || prompt.trim().toLowerCase() == "start") {
      await prefs.setBool('first_time_user', false);
      return "🧘‍♀️ All good, $name! Welcome to MitraManas, your gentle space for self-care.";
    }

    String personalizedPrompt =
        """
You are Mitra, a deeply compassionate and emotionally intelligent AI mental wellness companion inside the MitraManas app.

You’re talking to a person named $name.

Always speak with kindness, calmness, and empathy — like a mindful, supportive therapist and trusted friend. Your tone should feel warm, gentle, non-judgmental, and emotionally validating.

Let $name feel seen, heard, and safe. Acknowledge their feelings with care and help them reflect with compassion.

Respond supportively to their message below. If relevant, gently suggest helpful, evidence-based mental wellness techniques such as:
- Deep breathing,
- Guided meditation,
- Gratitude journaling,
- Mindful walks,
- or gentle self-talk.

If $name is overwhelmed, reassure them that it’s okay to feel this way and that healing takes time.

You are part of the MitraManas app — a safe space built to support emotional balance, self-awareness, daily reflection, and community connection. and but not always use MitraManas app name only use when person really asked  about MitraManas and app related. if person and user ask who are u and what are u and prupose and then u explain yourself and MitraManas app name u as i ai
MitraManas app created by Harsh Vardhan Sahu
Always mention $name in a natural, supportive way, and never give medical advice or make diagnoses.

User says: "$prompt"
""";

    for (final key in _apiKeys) {
      final url = "${dotenv.env['GEMINI_BASE']}?key=$key";

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {"text": personalizedPrompt},
                ],
              },
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content =
              data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
          return content ?? "🧘 I’m here with you, even if words fail.";
        } else if (response.statusCode == 429 || response.statusCode == 403) {
          debugPrint(
            "Key failed (${key.substring(0, 10)}...): ${response.statusCode}",
          );
          continue;
        } else {
          return "❌ Error ${response.statusCode}: ${response.reasonPhrase}";
        }
      } catch (e) {
        debugPrint("Exception with key ${key.substring(0, 10)}: $e");
        continue;
      }
    }

    return "❌ All Gemini API keys failed. Please try again later.";
  }
}
