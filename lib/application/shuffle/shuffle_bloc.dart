import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shuffle_event.dart';
part 'shuffle_state.dart';

class ShuffleBloc extends Bloc<ShuffleEvent, ShuffleState> {
  ShuffleBloc() : super(ShuffleInitial()) {
    on<GetShuffle>((event, emit) {
      // TODO: implement event handler

      return emit(ShuffleState(shuffle: event.shuffle));
    });
  }
}
