import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'repeat_event.dart';
part 'repeat_state.dart';

class RepeatBloc extends Bloc<RepeatEvent, RepeatState> {
  RepeatBloc() : super(RepeatInitial()) {
    on<GetRepeat>((event, emit) {
      // TODO: implement event handler

      return emit(RepeatState(repeat: event.repeat));
    });
  }
}
