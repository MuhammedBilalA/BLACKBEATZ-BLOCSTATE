import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationBloc() : super(AnimationStartedState()) {
    on<StartEventAnimation>((event, emit) async {
      bool newStart = event.startAnimation;

      // TODO: implement event handler
      return emit(AnimationState(startAnimation: newStart));
    });

  }
}

