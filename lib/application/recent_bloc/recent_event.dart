part of 'recent_bloc.dart';

@immutable
abstract class RecentEvent {}

class GetRcent extends RecentEvent{

}

class GetRecent extends RecentEvent {
  List<Songs> recentList;
  GetRecent({required this.recentList});
}