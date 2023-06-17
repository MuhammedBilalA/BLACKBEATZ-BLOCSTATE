part of 'repeat_cubit.dart';

class RepeatCubitState {
  bool repeat;
  RepeatCubitState({required this.repeat});
}

class RepeatCubitInitial extends RepeatCubitState {
  RepeatCubitInitial() : super(repeat: false);
}
