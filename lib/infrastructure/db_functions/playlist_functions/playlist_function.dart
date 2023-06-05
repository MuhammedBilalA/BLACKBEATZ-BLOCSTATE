import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:black_beatz/presentation/playlist_screens/playlist_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:black_beatz/domain/playlist_model/playlist_model.dart';

Future<List<EachPlaylist>> playlistCreating(playlistName) async {
  playListNotifier.insert(0, EachPlaylist(name: playlistName));
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  playlistdb.add(PlaylistClass(playlistName: playlistName));

  List<EachPlaylist> playlistReturn = [];
  playlistReturn.addAll(playListNotifier);
  return playlistReturn;
}

Future playlistAddDB(Songs addingSong, String playlistName) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');

  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistClass ubdatePlaylist = PlaylistClass(playlistName: playlistName);
      ubdatePlaylist.items.addAll(element.items);
      ubdatePlaylist.items.add(addingSong.id!);

      playlistdb.put(key, ubdatePlaylist);
      break;
    }
  }
}

Future playlistRemoveDB(Songs removingSong, String playlistName) async {
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistClass ubdatePlaylist = PlaylistClass(playlistName: playlistName);
      for (int item in element.items) {
        if (item == removingSong.id) {
          continue;
        }
        ubdatePlaylist.items.add(item);
      }
      playlistdb.put(key, ubdatePlaylist);
      break;
    }
  }
}

Future<List<EachPlaylist>> playlistdelete(int index) async {
  String playlistname = playListNotifier[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      playlistdb.delete(key);
      break;
    }
  }
  playListNotifier.removeAt(index);
 

  List<EachPlaylist> playlistr = [];

  playlistr.addAll(playListNotifier);
  return playlistr;

  // playlistBodyNotifier.notifyListeners();
}

Future playlistrename(int index, String newname) async {
  String playlistname = playListNotifier[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      element.playlistName = newname;
      playlistdb.put(key, element);
    }
  }
  playListNotifier[index].name = newname;

  // playlistBodyNotifier.notifyListeners();
}
