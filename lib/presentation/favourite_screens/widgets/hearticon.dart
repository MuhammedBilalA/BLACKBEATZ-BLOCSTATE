import 'package:black_beatz/infrastructure/db_functions/fav_db_functions/fav_functions.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/presentation/all_songs/all_songs.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/snackbar.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/home_screens/home_screen.dart';
import 'package:black_beatz/presentation/home_screens/widgets/vertical_scroll.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_unique_screen.dart';
import 'package:black_beatz/presentation/search_screens/search_screen.dart';
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
