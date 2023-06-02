import 'dart:async';
import 'package:black_beatz/database/songs/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/welcome_screen_1.dart';
import 'package:black_beatz/main.dart';
import 'package:black_beatz/screens/navbar_screens/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

List<Songs> allSongs = [];

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3, milliseconds: 500), () async {
      Fetching fetching = Fetching();
      await fetching.songfetch();
      checkUserLoggedIn();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
