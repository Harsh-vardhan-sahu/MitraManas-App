import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modals/daily_quote_model.dart';
import '../modals/mood_message_model.dart';

abstract class MeditationRemoteDataSource{
  Future<DailyQuoteModel> getDailyQuote();
  Future<MoodMessageModel> getMoodMessage(String mood);

}

class MeditationLocalDataSourceImpl implements MeditationRemoteDataSource{
  final http.Client client;

  MeditationLocalDataSourceImpl({required this.client});
  @override
  Future<DailyQuoteModel> getDailyQuote() async {
     final response = await client.get(
    Uri.parse('https://mitra-manas-backend.onrender.com/meditation/dailyQuote'),
    headers: {
    'Content-Type': 'application/json',},
    );

    if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
        return DailyQuoteModel.fromJson(jsonResponse);
    } else {
    throw Exception('Failed to load daily quote');
    }
  }

  @override
  Future<MoodMessageModel> getMoodMessage(String mood) async{
    final response = await client.get(
      Uri.parse('https://mitra-manas-backend.onrender.com/meditation/myMood/$mood'),
      headers: {
        'Content-Type': 'application/json',},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MoodMessageModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load mood quote');
    }
  }


}