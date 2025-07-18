

import '../../domain/entities/daily_quote.dart';
import '../../domain/entities/mood_message.dart';
import '../../domain/repositories/meditation_repository.dart';
import '../datasources/meditation_remote_datasource.dart';

class MeditationRepositoryImpl implements MeditationRepository{
  final MeditationRemoteDataSource remoteDataSource;
  MeditationRepositoryImpl({required this.remoteDataSource});
  @override
  Future<DailyQuote> getDailyQuote() async{
    return await remoteDataSource.getDailyQuote();
  }

  @override
  Future<MoodMessage> getMoodMessage(String mood)async {
    return await remoteDataSource.getMoodMessage(mood);
  }

}