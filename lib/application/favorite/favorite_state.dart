part of 'favorite_bloc.dart';

 class FavoriteState {
  List<Songs> favoritelist;
  FavoriteState({required this.favoritelist});
}

class FavoriteInitial extends FavoriteState {
  FavoriteInitial():super(favoritelist: []);
}
