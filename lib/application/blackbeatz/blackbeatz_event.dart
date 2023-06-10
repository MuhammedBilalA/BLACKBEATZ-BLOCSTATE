part of 'blackbeatz_bloc.dart';

@immutable
abstract class BlackBeatzEvent {}

class GetAllSongs extends BlackBeatzEvent {
  BuildContext context;
  GetAllSongs({required this.context});
}



class GetPlaylist extends BlackBeatzEvent {
  List<EachPlaylist> playlist;
  GetPlaylist({required this.playlist});
}

class GetPlusIcon extends BlackBeatzEvent {
  bool plusIcon;
  GetPlusIcon({required this.plusIcon});
}
