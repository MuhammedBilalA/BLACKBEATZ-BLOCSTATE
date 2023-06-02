import 'package:black_beatz/domain/fav_db_model/fav_model.dart';

import 'package:black_beatz/domain/playlist_model/playlist_model.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/presentation/all_songs/all_songs.dart';
import 'package:black_beatz/core/widgets/splash_screen.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/home_screens/widgets/vertical_scroll.dart';
import 'package:black_beatz/presentation/mostly_played/mostly_played.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:black_beatz/presentation/playlist_screens/playlist_screen.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_unique_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:permission_handler/permission_handler.dart';

bool notification = true;

class Fetching {
  final OnAudioQuery audioQuery = OnAudioQuery();

  songfetch() async {
    Box<Songs> songdb = await Hive.openBox('allsongsdb');

    if (songdb.isEmpty) {
      await fetchFromDevice();
    } else {
      allSongs.addAll(songdb.values);

      await favFetching();
      await playlistfetching();
      await recentfetch();
      await mostplayedfetch();
      await notificationFetching();
    }
  }

  //  request for permission 
  //of storage
  Future requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  // fetch songs from device storage after getting permission
  Future fetchFromDevice() async {
    //Asking for permission for device storage
    bool status = await requestPermission();
    if (status) {
      List<SongModel> fetchSongs = await audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
      );
      for (SongModel element in fetchSongs) {
        if (element.fileExtension == "mp3") {
          allSongs.add(
            Songs(
              songName: element.displayNameWOExt,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri,
            ),
          );
        }
      }
      Box<Songs> songdb = await Hive.openBox('allsongsdb');
      songdb.addAll(allSongs);
      await playlistfetching();
      await favFetching();
      await recentfetch();
      await mostplayedfetch();
      await notificationFetching();
    }
  }

  Future notificationFetching() async {
    Box<bool> notidb = await Hive.openBox('notification');
    if (notidb.isEmpty) {
      notification = true;
    } else {
      for (var element in notidb.values) {
        notification = element;
      }
    }
  }

  //Fetching Favorite songs...
  Future favFetching() async {
    List<Favmodel> favSongCheck = [];
    Box<Favmodel> favdb = await Hive.openBox('favorite');
    favSongCheck.addAll(favdb.values);
    for (var favs in favSongCheck) {
      int count = 0;
      for (var songs in allSongs) {
        if (favs.id == songs.id) {
          favoritelist.value.insert(0, songs);
          continue;
        } else {
          count++;
        }
      }
      if (count == allSongs.length) {
        var key = favs.key;
        favdb.delete(key);
      }
    }
  }

  //Fetching from recent

  recentfetch() async {
    Box<int> recentDb = await Hive.openBox('recent');
    List<Songs> recenttemp = [];
    for (int element in recentDb.values) {
      for (Songs song in allSongs) {
        if (element == song.id) {
          recenttemp.add(song);
          break;
        }
      }
    }
    recentListNotifier.value = recenttemp.reversed.toList();
  }

  //Fetching playlist ...
  Future playlistfetching() async {
    Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');

    for (PlaylistClass elements in playlistdb.values) {
      String playlistName = elements.playlistName;
      EachPlaylist playlistFetch = EachPlaylist(name: playlistName);
      for (int id in elements.items) {
        for (Songs songs in allSongs) {
          if (id == songs.id) {
            playlistFetch.container.insert(0, songs);
            break;
          }
        }
      }
      playListNotifier.value.insert(0, playlistFetch);
    }
  }

  //mostlyplayed fetching
  mostplayedfetch() async {
    Box<int> mostplayedDb = await Hive.openBox('mostplayed');
    if (mostplayedDb.isEmpty) {
      for (Songs song in allSongs) {
        mostplayedDb.put(song.id, 0);
      }
    } else {
      List<List<int>> mostplayedTemp = [];
      for (Songs song in allSongs) {
        int count = mostplayedDb.get(song.id)!;
        mostplayedTemp.add([song.id!, count]);
      }
      for (int i = 0; i < mostplayedTemp.length - 1; i++) {
        for (int j = i; j < mostplayedTemp.length; j++) {
          if (mostplayedTemp[i][1] < mostplayedTemp[j][1]) {
            List<int> temp = mostplayedTemp[i];
            mostplayedTemp[i] = mostplayedTemp[j];
            mostplayedTemp[j] = temp;
          }
        }
      }

      List<List<int>> temp = [];
      for (int i = 0; i < mostplayedTemp.length && i < 10; i++) {
        temp.add(mostplayedTemp[i]);
      }

      mostplayedTemp = temp;
      for (List<int> element in mostplayedTemp) {
        for (Songs song in allSongs) {
          if (element[0] == song.id && element[1] > 3) {
            mostPlayedList.add(song);
          }
        }
      }
    }
  }

  //refreshing allsongs...
  Future refreshAllSongs(context) async {
    Box<Songs> songdb = await Hive.openBox('allsongsdb');

    await songdb.clear();
    allSongs.clear();

    List<SongModel> fetchSongs = await audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );
    for (SongModel element in fetchSongs) {
      if (element.fileExtension == "mp3") {
        allSongs.add(
          Songs(
            songName: element.displayNameWOExt,
            artist: element.artist,
            duration: element.duration,
            id: element.id,
            songurl: element.uri,
          ),
        );
      }
    }
    // Box<Songs> songdb = await Hive.openBox('allsongsdb');
    await songdb.addAll(allSongs);
    // -------------------------fav fetching------------------
    List<Favmodel> favSongCheck = [];
    favoritelist.value.clear();
    Box<Favmodel> favdb = await Hive.openBox('favorite');
    favSongCheck.addAll(favdb.values);
    for (var favs in favSongCheck) {
      int count = 0;
      for (var songs in allSongs) {
        if (favs.id == songs.id) {
          favoritelist.value.insert(0, songs);
          continue;
        } else {
          count++;
        }
      }
      if (count == allSongs.length) {
        var key = favs.key;
        favdb.delete(key);
      }
    }
    // ---------------------------------------------------------
    // ---------------------recent refresh---------------------------------

    Box<int> recentDb = await Hive.openBox('recent');
    List<Songs> recenttemp = [];
    for (int element in recentDb.values) {
      for (Songs song in allSongs) {
        if (element == song.id) {
          recenttemp.add(song);
          break;
        }
      }
    }
    recentListNotifier.value = recenttemp.reversed.toList();

    // ---------------------------------------------------------

    //------------------mostlyplayed refresh------------------

    Box<int> mostplayedDb = await Hive.openBox('mostplayed');
    mostPlayedList.clear();
    if (mostplayedDb.isEmpty) {
      for (Songs song in allSongs) {
        mostplayedDb.put(song.id, 0);
      }
    } else {
      List<List<int>> mostplayedTemp = [];
      for (Songs song in allSongs) {
        int count = mostplayedDb.get(song.id)!;
        mostplayedTemp.add([song.id!, count]);
      }
      for (int i = 0; i < mostplayedTemp.length - 1; i++) {
        for (int j = i; j < mostplayedTemp.length; j++) {
          if (mostplayedTemp[i][1] < mostplayedTemp[j][1]) {
            List<int> temp = mostplayedTemp[i];
            mostplayedTemp[i] = mostplayedTemp[j];
            mostplayedTemp[j] = temp;
          }
        }
      }

      List<List<int>> temp = [];
      for (int i = 0; i < mostplayedTemp.length && i < 10; i++) {
        temp.add(mostplayedTemp[i]);
      }

      mostplayedTemp = temp;
      for (List<int> element in mostplayedTemp) {
        for (Songs song in allSongs) {
          if (element[0] == song.id && element[1] > 3) {
            mostPlayedList.add(song);
          }
        }
      }
    }

    // ------------playlist refresh starting------------------------
    playListNotifier.value.clear();

    Box<PlaylistClass> playlistdb = await Hive.openBox('playlist');

    for (PlaylistClass elements in playlistdb.values) {
      String playlistName = elements.playlistName;
      EachPlaylist playlistFetch = EachPlaylist(name: playlistName);

      playlistFetch.container.clear();
      for (int id in elements.items) {
        for (Songs songs in allSongs) {
          if (id == songs.id) {
            playlistFetch.container.insert(0, songs);
            break;
          }
        }
      }
      playListNotifier.value.insert(0, playlistFetch);
    }

    // -------------------------------------------------------------

    plusiconNotifier.notifyListeners();
    playlistBodyNotifier.notifyListeners();
    allsongBodyNotifier.notifyListeners();
    recentListNotifier.notifyListeners();
  }
}
