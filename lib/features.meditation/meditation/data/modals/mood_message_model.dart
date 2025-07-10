
import '../../domain/entities/mood_message.dart';

class MoodMessageModel extends  MoodMessage{
  MoodMessageModel({required String text}) : super(text: text);
  factory MoodMessageModel.fromJson(Map<String, dynamic> json){
    final text = json['text'];
    return MoodMessageModel(text: text);
  }

}