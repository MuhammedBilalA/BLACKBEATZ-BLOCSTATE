import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/application/recent_bloc/recent_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/recent_functions/recent_functions.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/presentation/welcome_screens/splash_screen.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

playingAudio(List<Songs> songs, int index) async {
  currentlyplaying = songs[index];
  playerMini.stop();
  playinglistAudio.clear();
  for (int i = 0; i < songs.length; i++) {
    playinglistAudio.add(Audio.file(songs[i].songurl!,
        metas: Metas(
          title: songs[i].songName,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        )));
  }
  await playerMini.open(Playlist(audios: playinglistAudio, startIndex: index),
      showNotification: notification,
      notificationSettings: const NotificationSettings(stopEnabled: false));
  playerMini.setLoopMode(LoopMode.playlist);
}

currentsongFinder(int? playingId, BuildContext context) async {
  for (Songs song in allSongs) {
    if (song.id == playingId) {
      currentlyplaying = song;
      break;
    }
  }
  List<Songs> returnrecentList = await recentadd(currentlyplaying!);
  context.read<RecentBloc>().add(GetRecent(recentList: returnrecentList));
}
