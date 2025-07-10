import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_daily_quote.dart';
import 'daily_quote_event.dart';
import 'daily_quote_state.dart';

class DailyQuoteBloc extends Bloc<DailyQuoteEvent, DailyQuoteState>{
  final GetDailyQuote getDailyQuote;

  DailyQuoteBloc({required this.getDailyQuote}) : super(DailyQuoteInitial()) {
    on<FetchDailyQuote>((event, emit) async {
      emit(DailyQuoteLoading());
      try{
        final dailyQuote = await getDailyQuote();
        emit(DailyQuoteLoaded(dailyQuote: dailyQuote));
      } catch(e) {
        emit(DailyQuoteError(message: e.toString()));
      }
    });
  }
}