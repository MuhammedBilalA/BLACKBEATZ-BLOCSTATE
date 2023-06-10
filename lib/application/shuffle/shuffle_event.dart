part of 'shuffle_bloc.dart';

@immutable
abstract class ShuffleEvent {}

class GetShuffle extends ShuffleEvent {
  bool shuffle;
  GetShuffle({required this.shuffle});
}
