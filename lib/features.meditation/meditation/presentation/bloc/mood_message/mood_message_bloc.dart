import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_mood_message.dart';
import 'mood_message_event.dart';
import 'mood_message_state.dart';

class MoodMessageBloc extends Bloc<MoodMessageEvent, MoodMessageState>{
  final GetMoodMessage getMoodMessage;

  MoodMessageBloc({required this.getMoodMessage}) : super(MoodMessageInitial()) {
    on<FetchMoodMessage>((event, emit) async {
      emit(MoodMessageLoading());
      try{
        final moodMessage = await getMoodMessage(event.mood);
        emit(MoodMessageLoaded(moodMessage: moodMessage));
      } catch(e) {
        emit(MoodMessageError(message: e.toString()));
      }
    });

    on<ResetMoodMessage>((event, emit){
      emit(MoodMessageInitial());
    });
  }
}