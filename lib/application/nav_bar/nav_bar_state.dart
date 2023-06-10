part of 'nav_bar_bloc.dart';

class NavBarState {
  int index;
  NavBarState({required this.index});
}

class NavBarInitial extends NavBarState {
  NavBarInitial() : super(index: 1);
}
