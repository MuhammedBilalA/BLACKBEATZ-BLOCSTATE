import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';

class EachPlaylist {
  String name;
  
  List<Songs> container = [];
  EachPlaylist({required this.name});
}
