import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/presentation/home_screens/widgets/vertical_scroll.dart';
import 'package:hive_flutter/hive_flutter.dart';

recentremove(Songs song) async {
  Box<int> recentDb = await Hive.openBox('recent');
  recentList.remove(song);
  // recentDb.delete(song.id);
  List<int> temp = [];
  temp.addAll(recentDb.values);

  for (int i = 0; i < temp.length; i++) {
    if (song.id == temp[i]) {
      recentDb.deleteAt(i);
    }
  }

   List<Songs> recent = [];
  recent.addAll(recentList);

  return recent;
}

Future<List<Songs>> recentadd(Songs song) async {
  Box<int> recentDb = await Hive.openBox('recent');
  List<int> temp = [];
  temp.addAll(recentDb.values);
  if (recentList.contains(song)) {
    recentList.remove(song);
    recentList.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id!);
      }
    }
  } else {
    recentList.insert(0, song);
    recentDb.add(song.id!);
  }
  if (recentList.length > 10) {
    recentList = recentList.sublist(0, 10);
    recentDb.deleteAt(0);
  }
  List<Songs> recent = [];
  recent.addAll(recentList);

  return recent;
  // recentListNotifier.notifyListeners();
}
