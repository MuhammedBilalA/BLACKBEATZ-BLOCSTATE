part of 'blackbeatz_bloc.dart';

@immutable
abstract class BlackBeatzEvent {}

class GetAllSongs extends BlackBeatzEvent {
  BuildContext context;
  GetAllSongs({required this.context});
}





