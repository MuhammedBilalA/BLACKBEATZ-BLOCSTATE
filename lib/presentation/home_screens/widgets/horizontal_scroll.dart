import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/playlist_screens/playlist_screen.dart';

import 'package:black_beatz/presentation/mostly_played/mostly_played.dart';
import 'package:flutter/material.dart';

class HorizontalScroll extends StatefulWidget {
  const HorizontalScroll({super.key});

  @override
  State<HorizontalScroll> createState() => _HorizontalScrollState();
}

class _HorizontalScrollState extends State<HorizontalScroll> {
  double screenWidth = 0;

  bool startAnimation = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: backgroundColorDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SizedBox(
              height: 212,
              child: AnimatedContainer(
                width: screenWidth,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 800),
                transform: Matrix4.translationValues(
                    startAnimation ? 0 : screenWidth, 0, 0),
                decoration: BoxDecoration(
                  color: transparentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    //Favourite screen card
                    verticalScrollScreens(
                      screen: const FavouriteScreen(),
                      context: context,
                      image: 'assets/images/oris.png',
                      heading: 'Favourite',
                      subheading: 'Favourite Songs',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),

                    //Playlist screen card
                    verticalScrollScreens(
                        screen: const PlaylistScreen(),
                        context: context,
                        image: 'assets/images/marshmelllow1.jpg',
                        heading: 'Playlist ',
                        subheading: 'Playlist Songs'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                    //Recentlyscreen card
                    verticalScrollScreens(
                      screen: const MostlyPlayed(),
                      context: context,
                      image: 'assets/images/aura.png',
                      heading: 'Top Beats',
                      subheading: 'Mostly Played Songs',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text(
              'RECENTLY PLAYED SONGS',
              style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  fontFamily: 'Peddana'),
            ),
          )
        ],
      ),
    );
  }

  // verticalScrollScreens for creating the vertical cards like favourite recents and this include the inkwell for navigating the screen
  Widget verticalScrollScreens(
      {context,
      required String image,
      required String heading,
      required String subheading,
      required screen}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.420,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  height: 65,
                  width: MediaQuery.of(context).size.width * 0.420,
                )),
            Positioned(
                bottom: 21,
                left: 17,
                child: Text(
                  heading,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      fontFamily: 'Peddana'),
                )),
            Positioned(
                bottom: 6,
                left: 17,
                child: Text(
                  subheading,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      fontFamily: 'Peddana'),
                ))
          ],
        ),
      ),
    );
  }
}
