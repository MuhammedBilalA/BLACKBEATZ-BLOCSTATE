import 'package:black_beatz/application/favorite/favorite_bloc.dart';
import 'package:black_beatz/application/search/search_bloc.dart';
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

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController _searchControllor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SearchBloc>().add(Search(query: '', allSongs: allSongs));
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColorDark,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 23, bottom: 20),
              child: TextFormField(
                onChanged: (value) {
                  // search(value);
                  context
                      .read<SearchBloc>()
                      .add(Search(query: value, allSongs: allSongs));
                },
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
            Expanded(child: searchFunc(context)),
          ],
        ),
      ),
    );
  }

  void clearText(context) {
    if (_searchControllor.text.isNotEmpty) {
      _searchControllor.clear();
      // data.notifyListeners();
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget searchFunc(BuildContext ctx1) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.searchList.isEmpty) {
          return searchEmpty();
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx1).size.height * 0.1),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                playingAudio(state.searchList, index);

                showBottomSheet(
                    backgroundColor: transparentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) {
                      return MiniPlayer();
                    });
              },
              child: ListtileCustomWidget(
                index: index,
                context: context,
                title: Text(
                  state.searchList[index].songName ??= 'unknown',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: whiteColor),
                ),
                subtitle: Text(
                  overflow: TextOverflow.ellipsis,
                  state.searchList[index].artist ??= 'unknown',
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
                      id: state.searchList[index].id!,
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
                trailing1: BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, statee) {
                    return Hearticon(
                      currentSong: state.searchList[index],
                      isfav:
                          statee.favoritelist.contains(state.searchList[index]),
                    );
                  },
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
                                          addToPlaylistSong:
                                              state.searchList[index],
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
          itemCount: state.searchList.length,
        );
      },
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
}
