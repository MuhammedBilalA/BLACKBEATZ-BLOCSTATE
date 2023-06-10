part of 'repeat_bloc.dart';

@immutable
abstract class RepeatEvent {}

class GetRepeat extends RepeatEvent {
  bool repeat;
  GetRepeat({required this.repeat});
}
