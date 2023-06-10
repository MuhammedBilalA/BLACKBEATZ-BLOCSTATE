part of 'nav_bar_bloc.dart';

@immutable
abstract class NavBarEvent {}

class GetIndex extends NavBarEvent {
  int index;
  GetIndex({required this.index});
}
