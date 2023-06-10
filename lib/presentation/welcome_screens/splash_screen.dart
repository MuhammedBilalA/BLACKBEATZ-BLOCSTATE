import 'dart:async';
import 'dart:developer';
import 'package:black_beatz/application/blackbeatz/blackbeatz_bloc.dart';
import 'package:black_beatz/application/favorite_bloc/favorite_bloc.dart';
import 'package:black_beatz/application/recent_bloc/recent_bloc.dart';

import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';

import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/welcome_screens/welcome_screen_1.dart';
import 'package:black_beatz/main.dart';
import 'package:black_beatz/presentation/navbar_screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

List<Songs> allSongs = [];

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   Timer(const Duration(seconds: 3, milliseconds: 1500), () async {
  //     // Fetching fetching = Fetching();
  //     // await fetching.songfetch();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(const Duration(seconds: 1, milliseconds: 750), () {
        context.read<BlackBeatzBloc>().add(GetAllSongs( context: context));
        // context.read<FavoriteBloc>().add(FetchAllFavorites());
      });

      Timer(const Duration(seconds: 2, milliseconds: 750), () async {
        //     // Fetching fetching = Fetching();
        //     // await fetching.songfetch();\
        await checkUserLoggedIn();
      });
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColorDark,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash.gif',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  gotoLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: ((ctx) => const WelcomeScreen1()),
      ),
    );
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getString(saveKeyName);
    if (userLoggedIn == null || userLoggedIn.isEmpty) {
      gotoLogin();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((ctx1) => const NavBar())));
    }
  }

  Future fetchBloc(BuildContext context) async {
    log('get all songs before');
    Timer(
        const Duration(
          seconds: 1,
        ),
        () {});
    log('get all songs after');
    log('get fav songs before');
    Timer(
        const Duration(
          seconds: 1,
        ),
        () {});
    log('get fav songs after');
    log('get recent  songs before');
    // Timer(const Duration(seconds: 1,), () {
    // });
    log('get recent  songs after');
  }
}
