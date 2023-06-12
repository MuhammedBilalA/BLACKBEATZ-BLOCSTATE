import 'dart:developer';

import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistInitial()) {
    on<GetPlaylist>((event, emit) async {
      // TODO: implement event handler

      Fetching fetching = Fetching();

      List<EachPlaylist> playlist = await fetching.playlistfetching();

      return emit(PlaylistState(playList: playlist, plusIcon: state.plusIcon));
    });

    on<PlaylistEventClass>(
      (event, emit) {
        log('this is playlist ${event.playList.length}');
        return emit(
            PlaylistState(playList: event.playList, plusIcon: state.plusIcon));
      },
    );

    on<GetPlusIcon>((event, emit) {
      return emit(
          PlaylistState(playList: state.playList, plusIcon: event.plusIcon));
    });

    on<SearchPlaylist>((event, emit) {
      // List<EachPlaylist> searchPlaylistList = [];

      state.searchPlaylist = state.playList
          .where((element) => element.name
              .toLowerCase()
              .contains(event.query.toLowerCase().trim()))
          .toList();
      log('playlist length ${state.searchPlaylist?.length}');

      return emit(PlaylistState(
          playList: state.playList, plusIcon: state.plusIcon,searchPlaylist: state.searchPlaylist));
    });
  }
}
