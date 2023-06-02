import 'package:hive_flutter/hive_flutter.dart';
part 'fav_model.g.dart';

@HiveType(typeId: 0)
class Favmodel extends HiveObject {
  @HiveField(0)
  int? id;
  Favmodel({required this.id});
}
