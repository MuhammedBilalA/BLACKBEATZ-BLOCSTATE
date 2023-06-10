import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nav_bar_event.dart';
part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial()) {
    on<GetIndex>((event, emit) {
      // TODO: implement event handler

      return emit(NavBarState(index: event.index));
    });
  }
}
