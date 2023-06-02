import 'package:black_beatz/database/playlist/playlist_model/playlist_model.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_class.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_screen.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_unique_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future playlistCreating(playlistName) async {
  playListNotifier.value.insert(0, EachPlaylist(name: playlistName));
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  playlistdb.add(PlaylistClass(playlistName: playlistName));
  
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
  plusiconNotifier.notifyListeners();
   
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

Future playlistdelete(int index) async {
  String playlistname = playListNotifier.value[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      playlistdb.delete(key);
      break;
    }
  }
  playListNotifier.value.removeAt(index);
  playListNotifier.notifyListeners();
  playlistBodyNotifier.notifyListeners();
}

Future playlistrename(int index, String newname) async {
  String playlistname = playListNotifier.value[index].name;
  Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');
  for (PlaylistClass element in playlistdb.values) {
    if (element.playlistName == playlistname) {
      var key = element.key;
      element.playlistName = newname;
      playlistdb.put(key, element);
    }
  }
  playListNotifier.value[index].name = newname;
  playListNotifier.notifyListeners();
  playlistBodyNotifier.notifyListeners();
}
