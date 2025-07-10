
import '../entities/daily_quote.dart';
import '../entities/mood_message.dart';

abstract class MeditationRepository{
  Future<DailyQuote> getDailyQuote();
  Future<MoodMessage> getMoodMessage(String mood);
}