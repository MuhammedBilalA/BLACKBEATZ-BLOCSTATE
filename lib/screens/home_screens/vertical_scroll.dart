import 'package:black_beatz/database/recent/recent_function/recent_functions.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/hearticon.dart';
import 'package:black_beatz/screens/common_widgets/listtilecustom.dart';
import 'package:black_beatz/screens/favourite_screens/favourite.dart';
import 'package:black_beatz/screens/playing_screen/mini_player.dart';
import 'package:black_beatz/screens/playing_screen/player_functions.dart';
import 'package:black_beatz/screens/playlist_screens/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<Songs>> recentListNotifier = ValueNotifier([]);

class VerticalScroll extends StatefulWidget {
  const VerticalScroll({super.key});

  @override
  State<VerticalScroll> createState() => _VerticalScrollState();
}

class _VerticalScrollState extends State<VerticalScroll> {
  double screenWidth = 0;

  bool startAnimation = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ValueListenableBuilder(
            valueListenable: recentListNotifier,
            builder: (context, value, child) =>
                (recentListNotifier.value.isNotEmpty)
                    ? verticalScroolfunction()
                    : const Center(
                        child: Text(
                          'Play Some Songs',
                          style: TextStyle(
                              color: whiteColor,
                              fontFamily: 'Peddana',
                              fontSize: 26),
                        ),
                      ),
          )),
    );
  }

  verticalScroolfunction() {
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
                  playingAudio(recentListNotifier.value, index);

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
                    recentListNotifier.value[index].songName ??= 'unknown',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: whiteColor),
                  ),
                  subtitle: Text(
                    recentListNotifier.value[index].artist ??= 'unknown',
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
                    id: recentListNotifier.value[index].id!,
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
                    currentSong: recentListNotifier.value[index],
                    isfav: favoritelist.value
                        .contains(recentListNotifier.value[index]),
                  ),
                  trailing2: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => AddToPlaylist(
                                    addToPlaylistSong:
                                        recentListNotifier.value[index],
                                  )));
                        } else {
                          recentremove(recentListNotifier.value[index]);
                          recentListNotifier.notifyListeners();
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
        itemCount: recentListNotifier.value.length);
  }
}
