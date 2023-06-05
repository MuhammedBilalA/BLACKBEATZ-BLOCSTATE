part of 'animation_bloc.dart';

 class AnimationState {
   bool startAnimation=false;

  AnimationState({required this.startAnimation});
}

class AnimationStartedState extends AnimationState {
  AnimationStartedState():super(startAnimation: false);
  
}


