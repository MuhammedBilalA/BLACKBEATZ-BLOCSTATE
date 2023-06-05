import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/domain/fav_db_model/fav_model.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future <List<Songs>> addFavourite(Songs song) async {
  favoritelist.insert(0, song);
  Box<Favmodel> favdb = await Hive.openBox('favorite');
  Favmodel temp = Favmodel(id: song.id);
  favdb.add(temp);

  List<Songs> addedlist = [];
  addedlist.addAll(favoritelist);
  return addedlist;
}

Future <List<Songs>>removeFavourite(Songs song) async {
  favoritelist.remove(song);
  List<Favmodel> templist = [];
  Box<Favmodel> favdb = await Hive.openBox('favorite');
  templist.addAll(favdb.values);
  for (var element in templist) {
    if (element.id == song.id) {
      var key = element.key;
      favdb.delete(key);
      break;
    }
  }
    List<Songs> addedlist = [];
  addedlist.addAll(favoritelist);
  return addedlist;
}
