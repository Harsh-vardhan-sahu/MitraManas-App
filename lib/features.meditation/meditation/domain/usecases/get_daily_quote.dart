
import '../entities/daily_quote.dart';
import '../repositories/meditation_repository.dart';

class GetDailyQuote{
  final MeditationRepository repository;
  GetDailyQuote({required this.repository});
  Future<DailyQuote> call() async{
    final quote = await repository.getDailyQuote();
    return quote;
  }

}