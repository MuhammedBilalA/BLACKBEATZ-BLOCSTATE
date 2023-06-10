import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<Search>((event, emit) {
      // TODO: implement event handler

      List<Songs> searchList = [];

      searchList = event.allSongs
          .where((element) => element.songName!
              .toLowerCase()
              .contains(event.query.toLowerCase().trim()))
          .toList();

      return emit(SearchState(searchList: searchList));
    });
  }
}
