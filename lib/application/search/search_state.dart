part of 'search_bloc.dart';

class SearchState {
  List<Songs> searchList;
  SearchState({required this.searchList});
}

class SearchInitial extends SearchState {
  SearchInitial() : super(searchList: []);
}
