import 'package:black_beatz/application/favorite/favorite_bloc.dart';
import 'package:black_beatz/application/playlist/playlist_bloc.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/listtilecustom.dart';
import 'package:black_beatz/infrastructure/db_functions/playlist_functions/playlist_function.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/player_functions.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/favourite_screens/widgets/hearticon.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/addto_playlist_screen.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:black_beatz/presentation/welcome_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistUniqueScreen extends StatelessWidget {
  final EachPlaylist playlist;

  const PlaylistUniqueScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
    return Scaffold(
      key: scaffoldkey,
      body: Scaffold(
          backgroundColor: backgroundColorLight,
          appBar: AppBar(
            backgroundColor: backgroundColorLight,
            title: Text(
              playlist.name.toUpperCase(),
              style: const TextStyle(
                  height: 3,
                  fontFamily: 'Peddana',
                  fontWeight: FontWeight.w600,
                  fontSize: 25),
            ),
            automaticallyImplyLeading: false,
            leading: InkWell(
                onTap: () {
                  // playlistBodyNotifier.notifyListeners();
                  Navigator.of(context).pop();
                },
                child: const Center(
                    child: FaIcon(
                  FontAwesomeIcons.angleLeft,
                ))),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () {
                      scaffoldkey.currentState?.showBottomSheet(
                          backgroundColor: transparentColor,
                          (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                  color: backgroundColorDark,
                                ),
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return listTileMethod(context, index);
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemCount: allSongs.length),
                              ));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.plus,
                      size: 26,
                    )),
              )
            ],
          ),
          body: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
            return (playlist.container.isNotEmpty)
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: InkWell(
                            onTap: () {
                              playingAudio(playlist.container, index);

                              showBottomSheet(
                                  backgroundColor: transparentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  context: context,
                                  builder: (context) {
                                    return MiniPlayer();
                                  });
                            },
                            child: listtileCalling(index, context)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox();
                    },
                    itemCount: playlist.container.length,
                  )
                : Center(
                    child: Text(
                      "ADD SOME SONGS TO ${playlist.name.toUpperCase()}",
                      style: const TextStyle(
                          color: whiteColor,
                          fontFamily: 'Peddana',
                          fontSize: 18),
                    ),
                  );
          })),
    );
  }

  ListtileCustomWidget listtileCalling(int index, BuildContext context) {
    return ListtileCustomWidget(
      index: index,
      context: context,
      leading: QueryArtworkWidget(
        size: 3000,
        quality: 100,
        artworkQuality: FilterQuality.high,
        artworkBorder: BorderRadius.circular(10),
        artworkFit: BoxFit.cover,
        id: playlist.container[index].id!,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/photo-1544785349-c4a5301826fd.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        '${playlist.container[index].songName}',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, color: whiteColor),
      ),
      subtitle: Text(
        "${playlist.container[index].artist}",
        style: const TextStyle(color: whiteColor),
      ),
      trailing1: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, fav) {
          return Hearticon(
            currentSong: playlist.container[index],
            isfav: fav.favoritelist.contains(playlist.container[index]),
          );
        },
      ),
      trailing2: PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddToPlaylist(
                      addToPlaylistSong: playlist.container[index])));
            } else {
              // removing from database
              playlistRemoveDB(playlist.container[index], playlist.name);
              // setState(() {
              //removing from playlist list only for view
              context.read<PlaylistBloc>().add(GetPlusIcon(plusIcon: true));

              playlist.container.removeAt(index);
              // });
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: backgroundColorDark,
          icon: const FaIcon(
            FontAwesomeIcons.ellipsisVertical,
            color: whiteColor,
            size: 26,
          ),
          itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text(
                    'Add To Playlist',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Peddana',
                        fontSize: 20.2),
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text(
                    'Remove From Playlist',
                    style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Peddana',
                        fontSize: 20.2),
                  ),
                )
              ]),
    );
  }

  ListTile listTileMethod(BuildContext context, int index) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.13,
          height: 47,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
      ),
      title: Text(
        allSongs[index].songName ??= 'unknown',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: whiteColor,
            fontFamily: 'Peddana',
            fontSize: 23,
            fontWeight: FontWeight.w400),
      ),
      trailing: PlusIcon(
        playlist: playlist,
        context: context,
        index: index,
        playlistName: playlist.name,
      ),
    );
  }
}

ValueNotifier plusiconNotifier = ValueNotifier([]);

class PlusIcon extends StatelessWidget {
  final String playlistName;
  final EachPlaylist playlist;
  final int index;
  final BuildContext context;
  PlusIcon(
      {super.key,
      required this.playlistName,
      required this.playlist,
      required this.index,
      required this.context});

  bool plus = true;
  @override
  Widget build(BuildContext context) {
    if (playlist.container.contains(allSongs[index])) {
      // context.read<PlaylistBloc>().add(GetPlusIcon(plusIcon: false));

      plus = false;
    } else {
      plus = true;
      // context.read<PlaylistBloc>().add(GetPlusIcon(plusIcon: true));
    }

    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            // setState(() {
            if (state.plusIcon == true) {
              plus = false;
              context.read<PlaylistBloc>().add(GetPlusIcon(plusIcon: false));

              //adding to playlist

              playlist.container.insert(0, allSongs[index]);
              playlistAddDB(allSongs[index], playlist.name);

              // plusiconNotifier.notifyListeners();
              // Navigator.pop(context);
            } else {
              plus = true;
              context.read<PlaylistBloc>().add(GetPlusIcon(plusIcon: true));

              playlist.container.remove(allSongs[index]);
              playlistRemoveDB(allSongs[index], playlistName);
              // plusiconNotifier.notifyListeners();
            }
            // });
          },
          child: (plus)
              ? const Icon(
                  Icons.add,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.remove_circle_outline_outlined,
                  color: redColor,
                ),
        );
      },
    );
  }
}
