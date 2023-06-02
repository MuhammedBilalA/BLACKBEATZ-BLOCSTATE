import 'package:black_beatz/database/favorite/dbmodel/fav_model.dart';
import 'package:black_beatz/database/playlist/playlist_model/playlist_model.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';

const saveKeyName = 'UserLoggedIn';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongsAdapter().typeId)) {
    Hive.registerAdapter(SongsAdapter());
  }
  if (!Hive.isAdapterRegistered(FavmodelAdapter().typeId)) {
    Hive.registerAdapter(FavmodelAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistClassAdapter().typeId)) {
    Hive.registerAdapter(PlaylistClassAdapter());
  }

  runApp(const BlackBeatz());
}

class BlackBeatz extends StatelessWidget {
  const BlackBeatz({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: ThemeData(primarySwatch: blueColor),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
