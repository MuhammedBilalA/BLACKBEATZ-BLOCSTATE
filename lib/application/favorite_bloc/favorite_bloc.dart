import 'dart:developer';

import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<FetchAllFavorites>((event, emit) async {
      Fetching fetching = Fetching();

      List<Songs> favoritelist = await fetching.favFetching();
      log('ithanu fav ${favoritelist.length}');
      return emit(FavoriteState(favoritelist: favoritelist));
    });

    on<GetFavorite>((event, emit) {
      // TODO: implement event handler

      return emit(FavoriteState(favoritelist: event.favoriteList));
    });
  }
}
