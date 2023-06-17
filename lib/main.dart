import 'package:black_beatz/application/animation/animation_bloc.dart';
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/application/favorite/favorite_bloc.dart';
import 'package:black_beatz/application/mostly_played/mostly_played_bloc.dart';
import 'package:black_beatz/application/nav_bar/nav_bar_bloc.dart';
import 'package:black_beatz/application/notification/notification_bloc.dart';
import 'package:black_beatz/application/playlist/playlist_bloc.dart';
import 'package:black_beatz/application/recent/recent_bloc.dart';

import 'package:black_beatz/application/repeat_cubit/repeat_cubit.dart';
import 'package:black_beatz/application/search/search_bloc.dart';
import 'package:black_beatz/application/shuffle_cubit/shuffle_cubit_cubit.dart';
import 'package:black_beatz/domain/playlist_model/playlist_model.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/welcome_screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:black_beatz/domain/fav_db_model/fav_model.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AnimationBloc(),
        ),
        BlocProvider(
          create: (context) => BlackBeatzBloc(),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => RecentBloc(),
        ),
       
        BlocProvider(
          create: (context) => NavBarBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(),
        ),
        BlocProvider(
          create: (context) => MostlyPlayedBloc(),
        ),
        BlocProvider(
          create: (context) => RepeatCubit(),
        ),
        BlocProvider(
          create: (context) => ShuffleCubit(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: blueColor),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
