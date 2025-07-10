import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyDJbnmLRria8j37GJd-mdEwOGXz9lCygg8";
  static const String _url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey";



  static Future<String> sendMessage(String prompt) async {
    if (prompt.trim().toLowerCase() == "start") {
      return "🧘‍♀️ All good! Welcome to MitraManas, your mental wellness companion.";
    }

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
      return content ?? "❌ No content returned.";
    } else {
      return "❌ Error ${response.statusCode}: ${response.reasonPhrase}\n${response.body}";
    }
  }
}
