import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:black_beatz/infrastructure/db_functions/mostlyplayed_functions/mostlyplayed.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/playing_screen/play_screen.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/player_functions.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

final AssetsAudioPlayer playerMini = AssetsAudioPlayer.withId('0');

Songs? currentlyplaying;
List<Audio> playinglistAudio = [];

class MiniPlayer extends StatelessWidget {
   MiniPlayer({super.key});

  bool miniplayerDone = true;

  @override
  Widget build(BuildContext context) {
    bool isEnteredToMostlyPlayed = false;

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  PlayScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3),
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.153,
          // height: 67,
          width: MediaQuery.of(context).size.width * 1,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: miniplayerGradient),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
              child: playerMini.builderCurrent(
                builder: (context, playing) {
                  int id = int.parse(playing.audio.audio.metas.id!);
                  currentsongFinder(id,context);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.14,
                            width: MediaQuery.of(context).size.width * 0.14,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)),
                            ),
                            child: ClipRRect(
                              child: QueryArtworkWidget(
                                keepOldArtwork: true,
                                artworkQuality: FilterQuality.high,
                                artworkBorder: const BorderRadius.only(
                                  bottomLeft: Radius.circular(3),
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                ),
                                artworkFit: BoxFit.cover,
                                id: int.parse(playing.audio.audio.metas.id!),
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(3),
                                    topLeft: Radius.circular(3),
                                    topRight: Radius.circular(3),
                                    bottomRight: Radius.circular(3),
                                  ),
                                  child: Image.asset(
                                    'assets/images/photo-1544785349-c4a5301826fd.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.003,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: Marquee(
                                      text: playerMini.getCurrentAudioTitle,
                                      pauseAfterRound:
                                          const Duration(seconds: 3),
                                      velocity: 30,
                                      blankSpace: 35,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor),
                                    ),
                                  ),
                                  PlayerBuilder.isPlaying(
                                    player: playerMini,
                                    builder: (context, isPlaying) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                if (miniplayerDone == true) {
                                                  miniplayerDone = false;
                                                  await playerMini.previous();

                                                  miniplayerDone = true;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.skip_previous,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.065,
                                                color: whiteColor,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                playerMini.playOrPause();
                                                
                                                  isPlaying = !isPlaying;
                                              
                                              },
                                              icon: Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.065,
                                                color: whiteColor,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                if (miniplayerDone == true) {
                                                  miniplayerDone = false;
                                                  await playerMini.next();

                                                  miniplayerDone = true;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.skip_next,
                                                color: whiteColor,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.065,
                                              )),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.003,
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.78,
                                        child:
                                            PlayerBuilder.realtimePlayingInfos(
                                          player: playerMini,
                                          builder: (context, infos) {
                                            Duration currentpos =
                                                infos.currentPosition;
                                            Duration total = infos.duration;

                                            double currentposvalue = currentpos
                                                .inMilliseconds
                                                .toDouble();
                                            double totalvalue =
                                                total.inMilliseconds.toDouble();
                                            double value =
                                                currentposvalue / totalvalue;
                                            if (!isEnteredToMostlyPlayed &&
                                                value > 0.5) {
                                              int id = int.parse(playing
                                                  .audio.audio.metas.id!);
                                              mostlyPlayedaddTodb(id);
                                              isEnteredToMostlyPlayed = true;
                                            }
                                            return LinearProgressIndicator(
                                              backgroundColor:
                                                  linearProgressIndicatorBackgroundColor,
                                              color: greenAccentColor,
                                              minHeight: 2.5,
                                              value: value,
                                            );
                                          },
                                        ),
                                      )))
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
