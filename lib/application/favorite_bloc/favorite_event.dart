part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent {}


class GetFavorite extends FavoriteEvent {
  List<Songs> favoriteList;
  GetFavorite({required this.favoriteList});
}

class FetchAllFavorites extends FavoriteEvent{
  
  
}