part of 'mostly_played_bloc.dart';

@immutable
abstract class MostlyPlayedEvent {}

class GetMostlyPlayed extends MostlyPlayedEvent {}

class AddToMostly extends MostlyPlayedEvent {
  List<Songs> mostly;
  AddToMostly({required this.mostly});
}
