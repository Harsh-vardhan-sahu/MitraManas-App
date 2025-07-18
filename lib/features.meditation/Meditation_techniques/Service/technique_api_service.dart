import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/meditation_technique_model.dart';


class TechniqueApiService {
  final String baseUrl = 'https://mitra-manas-backend.onrender.com';

  Future<List<MeditationTechnique>> fetchTechniques() async {
    final response = await http.get(Uri.parse('$baseUrl/meditation/techniques'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => MeditationTechnique.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load techniques');
    }
  }
}
