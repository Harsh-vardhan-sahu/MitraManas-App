import '../../domain/entities/daily_quote.dart';

class DailyQuoteModel extends DailyQuote {
  DailyQuoteModel({
    required String morningQuote,
    required String noonQuote,
    required String eveningQuote,
  }) : super(
    morningQuote: morningQuote,
    noonQuote: noonQuote,
    eveningQuote: eveningQuote,
  );

  factory DailyQuoteModel.fromJson(Map<String, dynamic> json) {
    return DailyQuoteModel(
      morningQuote: json['morningQuote'],
      noonQuote: json['noonQuote'],
      eveningQuote: json['eveningQuote'],
    );
  }

}
