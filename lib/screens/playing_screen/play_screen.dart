import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:black_beatz/database/mostlyplayed/mostlyplayed.dart';
import 'package:black_beatz/screens/common_widgets/hearticon.dart';
import 'package:black_beatz/screens/common_widgets/snackbar.dart';
import 'package:black_beatz/screens/favourite_screens/favourite.dart';
import 'package:black_beatz/screens/playing_screen/mini_player.dart';
import 'package:black_beatz/screens/playing_screen/player_functions.dart';
import 'package:black_beatz/screens/playlist_screens/addto_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({
    super.key,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

bool repeat = false;
bool shuffle = false;

class _PlayScreenState extends State<PlayScreen> {
  bool playerDone = true;

  @override
  Widget build(BuildContext context) {
    bool isEnteredToMostlyPlayed = false;
    return Scaffold(
      backgroundColor: const Color(0xFF53147A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 3, 6, 33),
        title: const Text(
          'NOW PLAYING',
          style: TextStyle(
              fontFamily: 'Peddana', fontWeight: FontWeight.w600, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xFF000000),
              Color(0xFF0B0E38),
              Color(0xFF53147A),
            ],
          ),
        ),
        child: playerMini.builderCurrent(builder: (context, playing) {
          int id = int.parse(playing.audio.audio.metas.id!);
          currentsongFinder(id);
          return SingleChildScrollView(
            child: Column(
              children: [
                AvatarGlow(
                  endRadius: 230,
                  showTwoGlows: true,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.36,
                    width: MediaQuery.of(context).size.width * 0.78,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurStyle: BlurStyle.outer,
                              blurRadius: 10,
                              color: Color.fromARGB(255, 140, 137, 137))
                        ],
                        borderRadius: BorderRadius.circular(170),
                        color: const Color.fromARGB(255, 6, 6, 0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(170),
                      child: QueryArtworkWidget(
                        size: 3000,
                        quality: 100,
                        keepOldArtwork: true,
                        artworkQuality: FilterQuality.high,
                        artworkBorder: BorderRadius.circular(10),
                        artworkFit: BoxFit.cover,
                        id: int.parse(playing.audio.audio.metas.id!),
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
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                      child: Marquee(
                        text: playerMini.getCurrentAudioTitle,
                        pauseAfterRound: const Duration(seconds: 2),
                        velocity: 50,
                        blankSpace: 15,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  playerMini.getCurrentAudioArtist
                              .toString()
                              .split(" ")[0]
                              .length >
                          20
                      ? '<unknown>'
                      : playerMini.getCurrentAudioArtist
                          .toString()
                          .split(" ")[0],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 28),
                  child: playerMini.builderRealtimePlayingInfos(
                      builder: (context, infos) {
                    Duration currentposition = infos.currentPosition;
                    Duration totalduration = infos.duration;

                    double currentposvalue =
                        currentposition.inMilliseconds.toDouble();
                    double totalvalue = totalduration.inMilliseconds.toDouble();
                    double value = currentposvalue / totalvalue;
                    if (!isEnteredToMostlyPlayed && value > 0.5) {
                      int id = int.parse(playing.audio.audio.metas.id!);
                      mostlyPlayedaddTodb(id);
                      isEnteredToMostlyPlayed = true;
                    }

                    return ProgressBar(
                      progress: currentposition,
                      total: totalduration,
                      progressBarColor: const Color.fromARGB(255, 182, 75, 249),
                      baseBarColor: const Color.fromARGB(190, 255, 255, 255),
                      bufferedBarColor: const Color.fromARGB(255, 182, 75, 249),
                      timeLabelTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      thumbColor: const Color.fromARGB(255, 182, 75, 249),
                      onSeek: (to) {
                        playerMini.seek(to);
                      },
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 10, bottom: 30),
                  child: Row(
                    children: [
                      const Spacer(
                        flex: 3,
                      ),
                      InkWell(
                        onTap: () async {
                          if (playerDone == true) {
                            playerDone = false;
                            await playerMini.previous();
                            playerDone = true;
                          }
                        },
                        borderRadius: BorderRadius.circular(35),
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      PlayerBuilder.isPlaying(
                        player: playerMini,
                        builder: (context, isPlaying) => InkWell(
                          radius: 150,
                          splashColor: Colors.white,
                          autofocus: true,
                          borderRadius: BorderRadius.circular(70),
                          onTap: () {
                            playerMini.playOrPause();
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(120),
                            ),
                            child: Center(
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.centerLeft,
                                    transform: GradientRotation(8),
                                    colors: [
                                      Color.fromARGB(255, 57, 7, 87),
                                      Color.fromARGB(255, 110, 12, 170),
                                      Color.fromARGB(255, 167, 32, 251),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                  color:
                                      const Color.fromARGB(255, 182, 75, 249),
                                ),
                                child: (isPlaying)
                                    ? const Icon(
                                        Icons.pause,
                                        size: 45,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      InkWell(
                        onTap: () async {
                          if (playerDone == true) {
                            playerDone = false;
                            await playerMini.next();
                            playerDone = true;
                          }
                        },
                        borderRadius: BorderRadius.circular(40),
                        child: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      )
                    ],
                  ),
                ),
                Container(
                  width: 250,
                  height: 55,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 10,
                    
                        )
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,

                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(255, 93, 5, 148),
                          Color.fromARGB(255, 161, 9, 255),
                          Color.fromARGB(255, 169, 33, 254),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (repeat == false) {
                              repeat = true;

                              playerMini.setLoopMode(LoopMode.single);
                              snackbarAdding(
                                  text: 'Added To Repeat', context: context);
                            } else {
                              repeat = false;
                              playerMini.setLoopMode(LoopMode.playlist);
                              snackbarRemoving(
                                  text: 'Removed From Repeat',
                                  context: context);
                            }
                          });
                        },
                        child: (repeat == false)
                            ? const Icon(
                                Icons.repeat,
                                size: 30,
                              )
                            : const Icon(
                                Icons.repeat_one_on_outlined,
                                size: 30,
                              ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (shuffle == false) {
                              shuffle = true;
                              playerMini.toggleShuffle();
                              snackbarAdding(
                                  text: 'Added To Shuffle', context: context);
                            } else {
                              shuffle = false;
                              playerMini.toggleShuffle();
                              snackbarRemoving(
                                  text: 'Removed From Shuffle',
                                  context: context);
                            }
                          });
                        },
                        child: (playerMini.isShuffling.value == false)
                            ? const Icon(
                                Icons.shuffle,
                                size: 28,
                              )
                            : const Icon(
                                Icons.shuffle_on_outlined,
                                size: 28,
                              ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Hearticon(
                        currentSong: currentlyplaying!,
                        isfav: favoritelist.value.contains(currentlyplaying),
                        refresh: true,
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => AddToPlaylist(
                                    addToPlaylistSong: currentlyplaying!,
                                  )));
                        },
                        child: const Icon(
                          Icons.playlist_add,
                          size: 32,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
