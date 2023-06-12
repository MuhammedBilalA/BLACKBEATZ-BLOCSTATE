part of 'playlist_bloc.dart';

class PlaylistState {
  List<EachPlaylist> playList;
  List<EachPlaylist>? searchPlaylist;
  bool plusIcon;
  PlaylistState({required this.playList, required this.plusIcon,this.searchPlaylist});
}

class PlaylistInitial extends PlaylistState {
  PlaylistInitial() : super(playList: [], plusIcon: true,searchPlaylist:[]);
}
