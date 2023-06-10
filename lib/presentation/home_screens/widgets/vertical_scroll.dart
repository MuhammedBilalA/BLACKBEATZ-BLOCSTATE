import 'package:black_beatz/application/animation/animation_bloc.dart';
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/application/favorite_bloc/favorite_bloc.dart';
import 'package:black_beatz/application/recent_bloc/recent_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/recent_functions/recent_functions.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/favourite_screens/widgets/hearticon.dart';
import 'package:black_beatz/core/widgets/listtilecustom.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/player_functions.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

List<Songs> recentList = [];

class VerticalScroll extends StatefulWidget {
  const VerticalScroll({super.key});

  @override
  State<VerticalScroll> createState() => _VerticalScrollState();
}

class _VerticalScrollState extends State<VerticalScroll> {
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    context.read<AnimationBloc>().add(StartEventAnimation(true));

    screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<AnimationBloc, AnimationState>(
      builder: (context, stateanimation) {
        return SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: BlocBuilder<RecentBloc, RecentState>(
                builder: (context, state) {
                  return (state.recentList.isNotEmpty)
                      ? verticalScroolfunction(
                          stateanimation.startAnimation, state)
                      : const Center(
                          child: Text(
                            'Play Some Songs',
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: 'Peddana',
                                fontSize: 26),
                          ),
                        );
                },
              )),
        );
      },
    );
  }

  verticalScroolfunction(startAnimation, state) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: AnimatedContainer(
              width: screenWidth,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 600 + (index * 200)),
              transform: Matrix4.translationValues(
                  startAnimation ? 0 : screenWidth, 0, 0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  playingAudio(state.recentList, index);

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
                    state.recentList[index].songName ??= 'unknown',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: whiteColor),
                  ),
                  subtitle: Text(
                    state.recentList[index].artist ??= 'unknown',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: whiteColor),
                  ),
                  leading: QueryArtworkWidget(
                    size: 3000,
                    quality: 100,
                    keepOldArtwork: true,
                    artworkQuality: FilterQuality.high,
                    artworkBorder: BorderRadius.circular(10),
                    artworkFit: BoxFit.cover,
                    id: state.recentList[index].id!,
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
                    builder: (context, favState) {
                      return Hearticon(
                        currentSong: state.recentList[index],
                        isfav: favState.favoritelist
                            .contains(state.recentList[index]),
                      );
                    },
                  ),
                  trailing2: PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => AddToPlaylist(
                                    addToPlaylistSong: state.recentList[index],
                                  )));
                        } else {
                          // recentListNotifier.notifyListeners();
                          List<Songs> returnrecentList =
                              await recentremove(recentList[index]);
                          context
                              .read<RecentBloc>()
                              .add(GetRecent(recentList: returnrecentList));
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
                                        height: 0.6,
                                        fontSize: 17),
                                  ),
                                  Icon(
                                    Icons.playlist_add,
                                    color: whiteColor,
                                  )
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'REMOVE FROM HISTORY',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Peddana',
                                        height: 0.6,
                                        fontSize: 17),
                                  ),
                                  Icon(
                                    Icons.history,
                                    color: whiteColor,
                                  )
                                ],
                              ),
                            )
                          ]),
                ),
              ),
            ),
            // ),
          );
        }),
        separatorBuilder: ((context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.000,
          );
        }),
        itemCount: state.recentList.length);
  }
}
