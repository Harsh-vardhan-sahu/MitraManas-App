import 'package:mitramanas/features.meditation/domain/repositories/meditation_repository.dart';

import '../entities/mood_message.dart';

class GetMoodMessage{
  final MeditationRepository repository;
  GetMoodMessage({required this.repository});

  Future<MoodMessage> call(String mood) async{
    final message = await repository.getMoodMessage(mood);
    return message;
  }
}