import '../../domain/entities/mood_message.dart';

class MoodMessageModel extends MoodMessage {
  MoodMessageModel({required String text}) : super(text: text);

  factory MoodMessageModel.fromJson(Map<String, dynamic> json) {
    // Log response (optional, for debugging)
    print('MoodMessageModel.fromJson => $json');

    // Ensure 'text' is present and valid
    final dynamic text = json['text'];
    if (text == null || text is! String) {
      throw Exception("Invalid or missing 'text' in mood message response.");
    }

    return MoodMessageModel(text: text);
  }
}
