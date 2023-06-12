import 'package:black_beatz/application/recent/recent_bloc.dart';

import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/home_screens/widgets/vertical_scroll.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/horizontal_scroll.dart';

ValueNotifier homeScreenNotifier = ValueNotifier([]);

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  bool floaticon = true;

  @override
  Widget build(BuildContext context) {
    if (currentlyplaying != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showBottomSheet(
            backgroundColor: transparentColor,
            context: context,
            // enableDrag: false,
            builder: (context) => MiniPlayer());
      });
    }
    return Scaffold(
        backgroundColor: backgroundColorDark,
        body: ValueListenableBuilder(
          valueListenable: homeScreenNotifier,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horizontal Screen of the home screen like favourite , playlist , recents
                HorizontalScroll(),
                // vertical screen of the home screen it is used to display mostlyplayed songs
                VerticalScroll(),
              ],
            ),
          ),
        ));
  }
}
