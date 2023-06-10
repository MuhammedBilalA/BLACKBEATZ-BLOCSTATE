import 'dart:developer';

import 'package:black_beatz/application/favorite_bloc/favorite_bloc.dart';
import 'package:black_beatz/application/recent_bloc/recent_bloc.dart';
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

      log('vannu');
      List<Songs> allSongs = await fetching.songfetch();
      log(allSongs.length.toString());
      event.context.read<FavoriteBloc>().add(FetchAllFavorites());
      event.context.read<RecentBloc>().add(GetRcent());

    
      List<Songs> mostPlayedList = await fetching.mostplayedfetch();
      List<EachPlaylist> playList = await fetching.playlistfetching();

      log('get all songs compleated ');
      return emit(BlackBeatzState(
        allSongs: allSongs,
        mostPlayedList: mostPlayedList,
        playList: playList,
        plusIcon: state.plusIcon,
      ));
    });
 

    on<GetPlaylist>(
      (event, emit) {
        log('this is playlist ${event.playlist.length}');
        return emit(BlackBeatzState(
          plusIcon: state.plusIcon,
          allSongs: state.allSongs,
          mostPlayedList: state.mostPlayedList,
          playList: event.playlist,
        ));
      },
    );
    on<GetPlusIcon>((event, emit) {
      return emit(BlackBeatzState(
          allSongs: state.allSongs,
          mostPlayedList: state.mostPlayedList,
          playList: state.playList,
          plusIcon: event.plusIcon));
    });
  }
}
