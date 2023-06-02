import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/presentation/home_screens/widgets/vertical_scroll.dart';
import 'package:hive_flutter/hive_flutter.dart';

recentremove(Songs song) async {
  Box<int> recentDb = await Hive.openBox('recent');
  recentListNotifier.value.remove(song);
  // recentDb.delete(song.id);
  List<int> temp = [];
  temp.addAll(recentDb.values);

  for (int i = 0; i < temp.length; i++) {
    if (song.id == temp[i]) {
      recentDb.deleteAt(i);
    }
  }
}

recentadd(Songs song) async {
  Box<int> recentDb = await Hive.openBox('recent');
  List<int> temp = [];
  temp.addAll(recentDb.values);
  if (recentListNotifier.value.contains(song)) {
    recentListNotifier.value.remove(song);
    recentListNotifier.value.insert(0, song);
    for (int i = 0; i < temp.length; i++) {
      if (song.id == temp[i]) {
        recentDb.deleteAt(i);
        recentDb.add(song.id!);
      }
    }
  } else {
    recentListNotifier.value.insert(0, song);
    recentDb.add(song.id!);
  }
  if (recentListNotifier.value.length > 10) {
    recentListNotifier.value = recentListNotifier.value.sublist(0, 10);
    recentDb.deleteAt(0);
  }
  recentListNotifier.notifyListeners();
}
