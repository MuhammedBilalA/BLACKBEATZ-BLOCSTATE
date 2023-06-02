import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/hearticon.dart';
import 'package:black_beatz/screens/common_widgets/listtilecustom.dart';
import 'package:black_beatz/screens/common_widgets/splash_screen.dart';
import 'package:black_beatz/screens/favourite_screens/favourite.dart';
import 'package:black_beatz/screens/playing_screen/mini_player.dart';
import 'package:black_beatz/screens/playing_screen/player_functions.dart';
import 'package:black_beatz/screens/playlist_screens/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier allsongBodyNotifier = ValueNotifier([]);

class AllSongs extends StatefulWidget {
  const AllSongs({super.key});

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
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

    if (currentlyplaying != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showBottomSheet(
            backgroundColor: transparentColor,
            context: context,
            builder: (context) => const MiniPlayer());
      });
    }

    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: ValueListenableBuilder(
        valueListenable: allsongBodyNotifier,
        builder: (context, value, child) =>
            (allSongs.isEmpty) ? songNotFound() : allSongsListView(),
      ),
    );
  }

  ListView allSongsListView() {
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
                playingAudio(allSongs, index);
                setState(() {});
              },
              child: ListtileCustomWidget(
                index: index,
                context: context,
                title: Text(
                  allSongs[index].songName ??= 'unknown',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: whiteColor),
                ),
                subtitle: Text(
                  '${allSongs[index].artist}',
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
                trailing1: Hearticon(
                  currentSong: allSongs[index],
                  isfav: favoritelist.value.contains(allSongs[index]),
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
                                  addToPlaylistSong: allSongs[index],
                                )));
                      }
                    },
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      itemCount: allSongs.length,
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
