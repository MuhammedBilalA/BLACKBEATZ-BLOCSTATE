import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

class EachPlaylist {
  String name;

  List<Songs> container = [];
  EachPlaylist({required this.name});
}
