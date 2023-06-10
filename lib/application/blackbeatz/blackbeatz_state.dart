part of 'blackbeatz_bloc.dart';

class BlackBeatzState {
  List<Songs> allSongs;
  List<Songs> mostPlayedList;
  List<EachPlaylist> playList;
  bool plusIcon;

  BlackBeatzState(
      {required this.allSongs,
      required this.mostPlayedList,
      required this.playList,
   required this.plusIcon});
}

class BlackBeatzInitial extends BlackBeatzState {
  BlackBeatzInitial()
      : super(
            allSongs: [],
            mostPlayedList: [],
            playList: [],
           plusIcon: true);
}
