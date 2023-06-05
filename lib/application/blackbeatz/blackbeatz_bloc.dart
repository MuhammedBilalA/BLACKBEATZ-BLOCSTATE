import 'dart:developer';

import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

      // List<Songs> favoritelist = await fetching.favFetching();
      // log('ithanu fav ${favoritelist.length}');
      // List<Songs> recentList = await fetching.recentfetch();
      List<Songs> mostPlayedList = await fetching.mostplayedfetch();
      List<EachPlaylist> playList = await fetching.playlistfetching();

      // log(allSongs.toString());
      return emit(BlackBeatzState(
          allSongs: allSongs,
          // favoritelist: favoritelist,
          mostPlayedList: mostPlayedList,
          playList: playList,
          plusIcon: state.plusIcon,
          // recentList: recentList,
          
          ));
    });
    // on<GetFavorite>(
    //   (event, emit) async {
    //     // Fetching fetching = Fetching();
    //     // log('vannu');
    //     // List<Songs> allSongs = await fetching.songfetch();
    //     // log(allSongs.length.toString());
    //     // log('ith block ${event.favoriteList.length.toString()}');
    //     // List<Songs> recentList = await fetching.recentfetch();
    //     // log('ith recent ${recentList.length.toString()}');
    //     // List<Songs> mostPlayedList = await fetching.mostplayedfetch();
    //     // List<EachPlaylist> playList = await fetching.playlistfetching();
    //     log('getfav state.allsongs:----${state.allSongs.length}');
    //     log('getfav event.favoriteList:----${event.favoriteList.length}');
    //     log('getfav state.mostPlayedList:----${state.mostPlayedList.length}');
    //     log('getfav state.playList:----${state.playList.length}');
    //     log('getfav state.recentList:----${state.recentList.length}');

    //     return emit(BlackBeatzState(
    //         allSongs: state.allSongs,
    //         favoritelist: event.favoriteList,
    //         mostPlayedList: state.mostPlayedList,
    //         playList: state.playList,
    //         plusIcon: state.plusIcon,
    //         recentList: state.recentList));
    //   },
    // );
 

    on<GetPlaylist>(
      (event, emit) {
        log('this is playlist ${event.playlist.length}');
        return emit(BlackBeatzState(
            plusIcon: state.plusIcon,
            allSongs: state.allSongs,
            // favoritelist: state.favoritelist,
            mostPlayedList: state.mostPlayedList,
            playList: event.playlist,
            ));
      },
    );
    on<GetPlusIcon>((event, emit) {
      return emit(BlackBeatzState(
          allSongs: state.allSongs,
          // favoritelist: state.favoritelist,
          mostPlayedList: state.mostPlayedList,
          playList: state.playList,
         
          plusIcon: event.plusIcon));
    });
  }
}
