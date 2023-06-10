part of 'shuffle_bloc.dart';

class ShuffleState {
  bool shuffle;
  ShuffleState({required this.shuffle});
}

class ShuffleInitial extends ShuffleState {
  ShuffleInitial() : super(shuffle: false);
}
