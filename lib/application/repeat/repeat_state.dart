part of 'repeat_bloc.dart';

class RepeatState {
  bool repeat;
  RepeatState({required this.repeat});
}

class RepeatInitial extends RepeatState {
  RepeatInitial() : super(repeat: false);
}
