import 'dart:developer';

import 'package:black_beatz/application/mostly_played/mostly_played_bloc.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'blackbeatz_event.dart';
part 'blackbeatz_state.dart';

class BlackBeatzBloc extends Bloc<BlackBeatzEvent, BlackBeatzState> {
  BlackBeatzBloc() : super(BlackBeatzInitial()) {
    on<GetAllSongs>((event, emit) async {
      // TODO: implement event handler'
      Fetching fetching = Fetching();
      event.context.read<MostlyPlayedBloc>().add(GetMostlyPlayed());

      log('vannu');
      List<Songs> allSongs = await fetching.songfetch(event.context);
      log(allSongs.length.toString());

      log('get all songs compleated ');
      return emit(BlackBeatzState(
        allSongs: allSongs,

        // plusIcon: state.plusIcon,
      ));
    });

    // on<GetPlusIcon>((event, emit) {
    //   return emit(BlackBeatzState(
    //       allSongs: state.allSongs,
    //       mostPlayedList: state.mostPlayedList,

    //       plusIcon: event.plusIcon));
    // });
  }
}
