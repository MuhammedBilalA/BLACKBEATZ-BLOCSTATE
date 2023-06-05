
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/favourite_screens/widgets/hearticon.dart';
import 'package:black_beatz/core/widgets/listtilecustom.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/player_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<Songs> favoritelist = [];

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});

  // bool startAnimation = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlackBeatzBloc, BlackBeatzState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColorLight,
          appBar: appBarFavorite(context, state),
          body: (state.favoritelist.isEmpty)
              ? const Center(
                  child: Text(
                    'Favourite is empty',
                    style: TextStyle(
                        color: whiteColor, fontFamily: 'Peddana', fontSize: 26),
                  ),
                )
              : favouritebuilderfunction(state),
        );
      },
    );
  }

// appbar of favourite screen
  AppBar appBarFavorite(BuildContext context, state) {
    return AppBar(
      backgroundColor: backgroundColorLight,
      title: const Text(
        'FAVOURITES',
        style: TextStyle(
            fontFamily: 'Peddana', fontWeight: FontWeight.w600, fontSize: 25),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: InkWell(
          onTap: () {
            // context.read<AnimationBloc>().add(StartEventAnimation(false));

            // Future.delayed(Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
            // });
          },
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.angleLeft,
            ),
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
              '${state.favoritelist.length} Songs',
              style: const TextStyle(
                  height: 2.2,
                  fontFamily: 'Peddana',
                  fontWeight: FontWeight.w400,
                  fontSize: 25),
            ),
          
        )
      ],
    );
  }

//list view separated of the favourite screen
  favouritebuilderfunction(state) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        // startAnimation = false;
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: InkWell(
            onTap: () {
              playingAudio(state.favoritelist, index);

              showBottomSheet(
                  backgroundColor: transparentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) {
                    return const MiniPlayer();
                  });
            },
            child: ListtileCustomWidget(
              index: index,
              context: context,
              title: Text(
                state.favoritelist[index].songName ??= 'unknown',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: whiteColor),
              ),
              subtitle: Text(
                state.favoritelist[index].artist ?? 'unknown',
                style: const TextStyle(color: whiteColor),
              ),
              leading: QueryArtworkWidget(
                size: 3000,
                quality: 100,
                artworkQuality: FilterQuality.high,
                artworkBorder: BorderRadius.circular(10),
                artworkFit: BoxFit.cover,
                id: state.favoritelist[index].id!,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/photo-1544785349-c4a5301826fd.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              trailing1: Hearticon(
                refresh: true,
                currentSong: state.favoritelist[index],
                isfav: true,
              ),
              trailing2: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => AddToPlaylist(
                                addToPlaylistSong: state.favoritelist[index],
                              )));
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: backgroundColorDark,
                  icon: const FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: whiteColor,
                    size: 26,
                  ),
                  itemBuilder: (context) => [
                       const PopupMenuItem(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                'ADD TO PLAYLIST',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Peddana',
                                    fontSize: 18),
                              ),
                              Icon(
                                Icons.playlist_add,
                                color: whiteColor,
                              )
                            ],
                          ),
                        )
                      ]),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 0,
        );
      },
      itemCount: state.favoritelist.length,
    );
  }
}
