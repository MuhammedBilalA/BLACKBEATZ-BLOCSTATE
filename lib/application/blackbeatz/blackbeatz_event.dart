part of 'blackbeatz_bloc.dart';

@immutable
abstract class BlackBeatzEvent {}

class GetAllSongs extends BlackBeatzEvent {}

class GetFavorite extends BlackBeatzEvent {
  List<Songs> favoriteList;
  GetFavorite({required this.favoriteList});
}

class GetRecent extends BlackBeatzEvent {
  List<Songs> recentList;
  GetRecent({required this.recentList});
}

class GetPlaylist extends BlackBeatzEvent {
  List<EachPlaylist> playlist;
  GetPlaylist({required this.playlist});
}

class GetPlusIcon extends BlackBeatzEvent {
  bool plusIcon;
  GetPlusIcon({required this.plusIcon});
}
