import 'package:black_beatz/application/animation/animation_bloc.dart';
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/application/favorite/favorite_bloc.dart';
import 'package:black_beatz/application/notification/notification_bloc.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/favourite_screens/widgets/hearticon.dart';
import 'package:black_beatz/core/widgets/listtilecustom.dart';
import 'package:black_beatz/presentation/welcome_screens/splash_screen.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/player_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier allsongBodyNotifier = ValueNotifier([]);

class AllSongs extends StatelessWidget {
  AllSongs({super.key});

  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    context.read<AnimationBloc>().add(StartEventAnimation(true));

    screenWidth = MediaQuery.of(context).size.width;

    // if (currentlyplaying != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    //   });
    // }

    return BlocBuilder<AnimationBloc, AnimationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColorDark,
          body: ValueListenableBuilder(
            valueListenable: allsongBodyNotifier,
            builder: (context, value, child) => (allSongs.isEmpty)
                ? songNotFound()
                : allSongsListView(state.startAnimation),
          ),
        );
      },
    );
  }

  Widget allSongsListView(startAnimation) {
    return BlocBuilder<BlackBeatzBloc, BlackBeatzState>(
      builder: (context, state) {
        // context
        //     .read<FavoriteBloc>()
        //     .add(GetFavorite(favoriteList: state.favoritelist));
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: AnimatedContainer(
                width: screenWidth,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 600 + (index * 200)),
                transform: Matrix4.translationValues(
                    startAnimation ? 0 : screenWidth, 0, 0),
                child: InkWell(
                  onTap: () async {
                    playingAudio(state.allSongs, index);
                    showBottomSheet(
                        backgroundColor: transparentColor,
                        context: context,
                        builder: (context) => MiniPlayer());
                  },
                  child: ListtileCustomWidget(
                    index: index,
                    context: context,
                    title: Text(
                      state.allSongs[index].songName ??= 'unknown',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor),
                    ),
                    subtitle: Text(
                      '${state.allSongs[index].artist}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: whiteColor),
                    ),
                    leading: QueryArtworkWidget(
                      size: 3000,
                      quality: 100,
                      artworkQuality: FilterQuality.high,
                      artworkBorder: BorderRadius.circular(10),
                      artworkFit: BoxFit.cover,
                      id: allSongs[index].id!,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/photo-1544785349-c4a5301826fd.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing1: BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, statee) {
                        return Hearticon(
                          currentSong: state.allSongs[index],
                          isfav: statee.favoritelist
                              .contains(state.allSongs[index]),
                        );
                      },
                    ),
                    trailing2: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: backgroundColorDark,
                        icon: const FaIcon(
                          FontAwesomeIcons.ellipsisVertical,
                          color: textColorLight,
                          size: 26,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => AddToPlaylist(
                                      addToPlaylistSong: state.allSongs[index],
                                    )));
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
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
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 0,
            );
          },
          itemCount: state.allSongs.length,
        );
      },
    );
  }

  Center songNotFound() {
    return const Center(
      child: Text(
        'Permission Is Not Granted Please Restart The Application',
        style: TextStyle(
            color: Color.fromARGB(255, 207, 195, 195),
            fontSize: 20,
            fontWeight: FontWeight.w300,
            fontFamily: 'Peddana'),
      ),
    );
  }
}
