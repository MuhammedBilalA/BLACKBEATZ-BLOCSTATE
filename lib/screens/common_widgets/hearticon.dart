import 'package:black_beatz/database/favorite/fav_db_function/fav_functions.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/screens/all_songs/all_songs.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/snackbar.dart';
import 'package:black_beatz/screens/favourite_screens/favourite.dart';
import 'package:black_beatz/screens/home_screens/home_screen.dart';
import 'package:black_beatz/screens/home_screens/vertical_scroll.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_unique_screen.dart';
import 'package:black_beatz/screens/search_screens/search_screen.dart';
import 'package:flutter/material.dart';

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
        onTap: () {
          setState(() {
            if (widget.isfav) {
              widget.isfav = false;

              removeFavourite(widget.currentSong);

              snackbarRemoving(
                  text: 'Removed From Favourite', context: context);
            } else {
              widget.isfav = true;

              addFavourite(widget.currentSong);
              snackbarAdding(text: 'Added To Favourite', context: context);
            }
            if (widget.refresh != null) {
              favoritelist.notifyListeners();
              allsongBodyNotifier.notifyListeners();
              homeScreenNotifier.notifyListeners();
              recentListNotifier.notifyListeners();
              plusiconNotifier.notifyListeners();
              data.notifyListeners();
            }
          });
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
