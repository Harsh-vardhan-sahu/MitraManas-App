import 'package:mitramanas/features.meditation/domain/repositories/meditation_repository.dart';

import '../entities/daily_quote.dart';

class GetDailyQuote{
  final MeditationRepository repository;
  GetDailyQuote({required this.repository});
  Future<DailyQuote> call() async{
    final quote = await repository.getDailyQuote();
    return quote;
  }

}