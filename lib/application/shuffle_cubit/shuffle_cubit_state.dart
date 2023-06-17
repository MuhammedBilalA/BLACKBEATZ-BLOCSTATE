part of 'shuffle_cubit_cubit.dart';

class ShuffleCubitState {
  bool shuffle;
  ShuffleCubitState({required this.shuffle});
}

class ShuffleCubitInitial extends ShuffleCubitState {
  ShuffleCubitInitial() : super(shuffle: false);
}
