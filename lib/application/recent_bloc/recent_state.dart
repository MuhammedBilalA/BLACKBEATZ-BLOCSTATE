part of 'recent_bloc.dart';

class RecentState {
  List<Songs> recentList;
  RecentState({required this.recentList});
}

class RecentInitial extends RecentState {
  RecentInitial():super(recentList: []);
  
}
