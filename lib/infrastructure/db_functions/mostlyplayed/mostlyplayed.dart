import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/presentation/welcome_screens/splash_screen.dart';
import 'package:black_beatz/presentation/mostly_played/mostly_played.dart';
import 'package:hive_flutter/hive_flutter.dart';

// -----adding to mostly playeddb
mostlyPlayedaddTodb(int id) async {
  Box<int> mostplayeddb = await Hive.openBox('mostplayed');
  int count = mostplayeddb.get(id)!;
  mostplayeddb.put(id, count + 1);
  await mostlyplayedaddtolist();
}

// mostly played list refreshing ----

mostlyplayedaddtolist() async {
  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  mostPlayedList.clear();

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
