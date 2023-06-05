part of 'blackbeatz_bloc.dart';

class BlackBeatzState {
  List<Songs> allSongs;
  List<Songs> favoritelist;
  List<Songs> mostPlayedList;
  List<Songs> recentList;
  List<EachPlaylist> playList;

  BlackBeatzState({required this.allSongs,required this.favoritelist,required this.mostPlayedList,required this.playList,required this.recentList});
}

class BlackBeatzInitial extends BlackBeatzState {
  BlackBeatzInitial() : super(allSongs: [],favoritelist: [],mostPlayedList: [],playList: [],recentList: []);
}
