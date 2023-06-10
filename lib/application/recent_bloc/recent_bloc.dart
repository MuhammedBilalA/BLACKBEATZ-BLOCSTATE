import 'dart:developer';

import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  RecentBloc() : super(RecentInitial()) {
    on<GetRcent>((event, emit) async {
      // TODO: implement event handler

      Fetching fetching = Fetching();
      List<Songs> recentList = await fetching.recentfetch();
      log('REcent fetchg length ${recentList.length}');

      return emit(RecentState(recentList: recentList));
    });

    on<GetRecent>(
      (event, emit) async {

        log('GetRecent event.recentList:----${event.recentList.length}');

        return emit(RecentState(recentList: event.recentList));
      },
    );
  }
}
