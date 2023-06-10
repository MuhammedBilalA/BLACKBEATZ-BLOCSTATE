import 'dart:developer';

import 'package:black_beatz/application/favorite_bloc/favorite_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/fav_db_functions/fav_functions.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Hearticon extends StatelessWidget {
  Songs currentSong;
  bool isfav;
  
  Hearticon(
      {super.key,
      required this.currentSong,
      required this.isfav,
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        return InkWell(
            onTap: () async {
              if (isfav) {
                isfav = false;

                List<Songs> returnList =
                    await removeFavourite(currentSong);

                context
                    .read<FavoriteBloc>()
                    .add(GetFavorite(favoriteList: returnList));

                snackbarRemoving(
                    text: 'Removed From Favourite', context: context);
              } else {
                isfav = true;

                List<Songs> returnList = await addFavourite(currentSong);
                context
                    .read<FavoriteBloc>()
                    .add(GetFavorite(favoriteList: returnList));

                   log('adding fav state.favoritelist  ${state.favoritelist.length}');
                   log('adding fav returnList  ${returnList.length}');
                snackbarAdding(text: 'Added To Favourite', context: context);
              }
             
              
            },
            child: (isfav)
                ? const Icon(
                    Icons.favorite_sharp,
                    size: 33,
                    color: backgroundColorDark,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: backgroundColorDark,
                    size: 33,
                  ));
      },
    );
  }
}
