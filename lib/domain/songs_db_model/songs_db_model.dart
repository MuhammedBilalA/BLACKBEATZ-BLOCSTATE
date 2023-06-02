import 'package:hive_flutter/hive_flutter.dart';
part 'songs_db_model.g.dart';

@HiveType(typeId: 2)
class Songs  {
  @HiveField(0)
  String? songName;

  @HiveField(1)
  String? artist;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  String? songurl;

  @HiveField(4)
  int? id;

  Songs(
      {required this.songName,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songurl});
}
