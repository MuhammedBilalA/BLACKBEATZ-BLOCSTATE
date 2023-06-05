part of 'animation_bloc.dart';

@immutable
abstract class AnimationEvent {}

class StartEventAnimation extends AnimationEvent {
 final  bool startAnimation;

  StartEventAnimation(this.startAnimation);
}


