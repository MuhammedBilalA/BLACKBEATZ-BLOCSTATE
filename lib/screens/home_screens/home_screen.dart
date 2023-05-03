import 'package:black_beatz/screens/home_screens/vertical_scroll.dart';
import 'package:black_beatz/screens/playing_screen/mini_player.dart';
import 'package:flutter/material.dart';
import 'horizontal_scroll.dart';

ValueNotifier homeScreenNotifier = ValueNotifier([]);

class HomeScreen extends StatelessWidget {
HomeScreen({super.key});

  bool floaticon = true;

  @override
  Widget build(BuildContext context) {
    if (currentlyplaying != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            // enableDrag: false,
            builder: (context) => const MiniPlayer());
      });
    }
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 45, 10, 67),
        body: ValueListenableBuilder(
          valueListenable: homeScreenNotifier,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
