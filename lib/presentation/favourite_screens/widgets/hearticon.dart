import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/fav_db_functions/fav_functions.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Hearticon extends StatefulWidget {
  Songs currentSong;
  bool isfav;
  bool? refresh;
  Hearticon(
      {super.key,
      required this.currentSong,
      required this.isfav,
      this.refresh});

  @override
  State<Hearticon> createState() => _HearticonState();
}

class _HearticonState extends State<Hearticon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          // setState(()async {
          if (widget.isfav) {
            widget.isfav = false;

            List<Songs> returnList = await removeFavourite(widget.currentSong);
            context
                .read<BlackBeatzBloc>()
                .add(GetFavorite(favoriteList: returnList));
            snackbarRemoving(text: 'Removed From Favourite', context: context);
          } else {
            widget.isfav = true;

            List<Songs> returnList = await addFavourite(widget.currentSong);
            context
                .read<BlackBeatzBloc>()
                .add(GetFavorite(favoriteList: returnList));
            snackbarAdding(text: 'Added To Favourite', context: context);
          }
          if (widget.refresh != null) {

            // favoritelist.notifyListeners();
            // allsongBodyNotifier.notifyListeners();
            // homeScreenNotifier.notifyListeners();
            // recentListNotifier.notifyListeners();
            // plusiconNotifier.notifyListeners();
            // data.notifyListeners();
          }
          // });
        },
        child: (widget.isfav)
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
  }
}
