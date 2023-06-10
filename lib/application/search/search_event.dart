part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class Search extends SearchEvent {
  String query;
  List<Songs> allSongs;
  Search({required this.query,required this.allSongs});
}
