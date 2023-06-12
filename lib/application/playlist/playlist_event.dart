part of 'playlist_bloc.dart';

@immutable
abstract class PlaylistEvent {}

class GetPlaylist extends PlaylistEvent {}

class PlaylistEventClass extends PlaylistEvent {
  List<EachPlaylist> playList;
  PlaylistEventClass({required this.playList});
}

class GetPlusIcon extends PlaylistEvent {
  bool plusIcon;
  GetPlusIcon({required this.plusIcon});
}

class SearchPlaylist extends PlaylistEvent {
  String query;
  // List<EachPlaylist> each;
  SearchPlaylist({required this.query});
}
