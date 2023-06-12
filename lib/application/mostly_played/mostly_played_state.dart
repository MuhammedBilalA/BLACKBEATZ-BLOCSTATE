part of 'mostly_played_bloc.dart';

class MostlyPlayedState {
  List<Songs> mostPlayedList;
  MostlyPlayedState({required this.mostPlayedList});
}

class MostlyPlayedInitial extends MostlyPlayedState {
  MostlyPlayedInitial() : super(mostPlayedList: []);
}
