import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
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

ValueNotifier<List<Songs>> data = ValueNotifier([]);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchControllor = TextEditingController();
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColorDark,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 23, bottom: 20),
              child: TextFormField(
                onChanged: (value) => search(value),
                controller: _searchControllor,
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(top: 10, left: 25, right: 20),
                      child: FaIcon(
                        FontAwesomeIcons.searchengin,
                        size: 30,
                        color: Color.fromARGB(255, 249, 249, 249),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding:
                          const EdgeInsets.only(top: 2, left: 25, right: 20),
                      child: InkWell(
                        onTap: () {
                          clearText(context);
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          size: 30,
                          color: Color.fromARGB(255, 226, 226, 226),
                        ),
                      ),
                    ),
                    fillColor: const Color(0xFFA416FB),
                    filled: true,
                    hintText: 'Search Song',
                    hintStyle: const TextStyle(
                        color: textColorLight,
                        fontFamily: 'Peddana',
                        height: .5,
                        fontSize: 25),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pinkAccent),
                        borderRadius: BorderRadius.circular(30)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: data,
              builder: (context, value, child) => Expanded(
                  child: _searchControllor.text.isEmpty ||
                          _searchControllor.text.trim().isEmpty
                      ? searchFunc(context)
                      : data.value.isEmpty
                          ? searchEmpty()
                          : searchfound(context)),
            )
          ],
        ),
      ),
    );
  }

  void clearText(context) {
    if (_searchControllor.text.isNotEmpty) {
      _searchControllor.clear();
      data.notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget searchFunc(BuildContext ctx1) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx1).size.height * 0.1),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          width: screenWidth,
          curve: Curves.linear,
          duration: Duration(milliseconds: 600 + (index * 200)),
          transform:
              Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
          child: InkWell(
            onTap: () {
              playingAudio(allSongs, index);

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
                allSongs[index].songName ??= 'unknown',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: whiteColor),
              ),
              subtitle: Text(
                overflow: TextOverflow.ellipsis,
                allSongs[index].artist ??= 'unknown',
                style: const TextStyle(color: whiteColor),
              ),
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                width: MediaQuery.of(context).size.width * 0.14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: QueryArtworkWidget(
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
                    color: whiteColor,
                    size: 30,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => AddToPlaylist(
                                        addToPlaylistSong: allSongs[index],
                                      )));
                            },
                            child: const Text(
                              'ADD TO PLAYLIST',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Peddana',
                                  fontSize: 22),
                            ),
                          ),
                        )
                      ]),
            ),
          ),
        ),
      ),
      itemCount: allSongs.length,
    );
  }

  Widget searchEmpty() {
    return const SizedBox(
      child: Center(
        child: Text(
          'Song Not Found',
          style: TextStyle(
              fontSize: 25,
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Peddana'),
        ),
      ),
    );
  }

  Widget searchfound(BuildContext ctx2) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            playingAudio(data.value, index);

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
              data.value[index].songName!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: whiteColor),
            ),
            subtitle: Text(
              '${data.value[index].artist}',
              style: const TextStyle(color: whiteColor),
            ),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: QueryArtworkWidget(
                  size: 3000,
                  quality: 100,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(10),
                  artworkFit: BoxFit.cover,
                  id: data.value[index].id!,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/photo-1544785349-c4a5301826fd.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            trailing1: Hearticon(
              currentSong: data.value[index],
              isfav: favoritelist.value.contains(data.value[index]),
            ),
            trailing2: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: backgroundColorDark,
                icon: const FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: whiteColor,
                  size: 30,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => AddToPlaylist(
                                    addToPlaylistSong: data.value[index])));
                          },
                          child: const Text(
                            'ADD TO PLAYLIST',
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Peddana',
                                fontSize: 22),
                          ),
                        ),
                      )
                    ]),
          ),
        ),
      ),
      itemCount: data.value.length,
    );
  }

  search(String searchtext) {
    data.value = allSongs
        .where((element) => element.songName!
            .toLowerCase()
            .contains(searchtext.toLowerCase().trim()))
        .toList();
  }
}
