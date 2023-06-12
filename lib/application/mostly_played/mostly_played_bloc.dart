import 'dart:developer';

import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mostly_played_event.dart';
part 'mostly_played_state.dart';

class MostlyPlayedBloc extends Bloc<MostlyPlayedEvent, MostlyPlayedState> {
  MostlyPlayedBloc() : super(MostlyPlayedInitial()) {
    on<GetMostlyPlayed>((event, emit) async {
      // TODO: implement event handler'
      Fetching fetching = Fetching();
      List<Songs> mostPlayedList = await fetching.mostplayedfetch();
      log('most list length  ${mostPlayedList.length}');
      return emit(MostlyPlayedState(mostPlayedList: mostPlayedList));
    });

    on<AddToMostly>((event, emit) {
      log('most list length adding ${event.mostly.length}');

      return emit(MostlyPlayedState(mostPlayedList: event.mostly));
    });
  }
}
