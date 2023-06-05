import 'dart:async';

import 'package:black_beatz/application/animation/animation_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/songs_db_functions/songs_db_functions.dart';
import 'package:black_beatz/presentation/all_songs/all_songs.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/home_screens/home_screen.dart';
import 'package:black_beatz/presentation/navbar_screens/widgets/privacy_policy_screen.dart';
import 'package:black_beatz/presentation/navbar_screens/widgets/terms_and_conditions_screen.dart';
import 'package:black_beatz/presentation/search_screens/search_screen.dart';
import 'package:black_beatz/presentation/user_screen/user_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 1;
  int pressedButtonNo = 1;
  final screens = [
    HomeScreen(),
     AllSongs(),
     UserScreen(),
  ];
  final titles = [
    Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Image.asset(
        'assets/images/blackbeatz.png',
        width: 200,
      ),
    ),
    const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        'ALL SONGS',
        style: TextStyle(
          fontFamily: 'peddana',
          fontSize: 28,
        ),
      ),
    ),
    const Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        'USER',
        style: TextStyle(
          fontFamily: 'peddana',
          fontSize: 28,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDark,
      drawer: drawermethod(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
        title: titles[index],
        actions: [
          IconButton(
              tooltip: 'refresh',
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        color: transparentColor,
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 200, 111, 255),
                          strokeWidth: 6,
                        ),
                      ),
                    );
                  },
                );
                Timer(const Duration(seconds: 2), () async {
                  Fetching fetch = Fetching();
                  await fetch.refreshAllSongs(context);
                  Navigator.of(context).pop();
                });
              },
              icon: const Icon(
                Icons.sync,
                size: 28,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => SearchScreen()));
                },
                icon: const FaIcon(
                  FontAwesomeIcons.searchengin,
                  size: 27,
                )),
          )
        ],
      ),
      body: screens[index],
      bottomNavigationBar: curvedNavBar(),
    );
  }

  CurvedNavigationBar curvedNavBar() {
    return CurvedNavigationBar(
      backgroundColor: transparentColor,
      color: curvedNavBarColor,
      index: index,
      items: [
        FaIcon(FontAwesomeIcons.houseChimney,
            color:
                (pressedButtonNo == 0) ? (whiteColor) : curvedNavBarIconColor),
        FaIcon(FontAwesomeIcons.indent,
            color:
                (pressedButtonNo == 1) ? (whiteColor) : curvedNavBarIconColor),
        FaIcon(FontAwesomeIcons.userLarge,
            color:
                (pressedButtonNo == 2) ? (whiteColor) : curvedNavBarIconColor),
      ],
      height: 60,
      onTap: (index) => setState(() {
        if (pressedButtonNo != index) {
          context.read<AnimationBloc>().add(StartEventAnimation(false));
        }
        this.index = index;
        pressedButtonNo = index;
        
      }),
    );
  }

  Drawer drawermethod() {
    return Drawer(
      backgroundColor: backgroundColorDark,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Image.asset(
            'assets/images/blackbeatz.png',
            height: MediaQuery.of(context).size.height * 0.054,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.asset(
                'assets/images/drawerimage.png',
                height: MediaQuery.of(context).size.height * 0.26,
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const TermsAndConditionsScreen()));
            },
            child: DrawerlistCustom(
              title: 'Terms and  Conditions',
              icon: FontAwesomeIcons.triangleExclamation,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const PrivacyPolicyScreen()));
            },
            child: DrawerlistCustom(
              title: 'Privacy Policy',
              icon: FontAwesomeIcons.gavel,
            ),
          ),
          InkWell(
            onTap: () {
              aboutUs();
            },
            child: DrawerlistCustom(
                title: 'About Us', icon: FontAwesomeIcons.circleInfo),
          ),
          InkWell(
            onTap: () async {
              await Share.share(
                  'https://play.google.com/store/apps/details?id=com.brototype.black_beatz');
            },
            child: DrawerlistCustom(
              title: 'Share',
              icon: FontAwesomeIcons.cloudsmith,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notification',
                  style: TextStyle(
                    color: drawerlistTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    // fontSize: 16,
                  ),
                ),
                Switch(
                  activeColor: notificationSwitchColor,
                  value: notification,
                  onChanged: (value) {
                    setState(() {
                      notificationFunction(value);
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VERSION 1.0.1',
                style: TextStyle(
                    color: versionTextColor,
                    fontSize: MediaQuery.of(context).size.height * 0.008,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> aboutUs() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: aboutUsBackgroundColor,
            title: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset('assets/images/blackbeatz.png')),
            content: const Text(
              'BLACK BEATZ is the ultimate music player for those  who love to groove to the rhythm of their favorite tunes .if you are looking for a music player that can handle any genre, any mood, and any occasion, look no further than BLACK BEATZ .BLACK BEATZ is more than a music player. it’s your musical companion . Get yours now and feel the beast',
              style: TextStyle(
                  color: whiteColor, fontFamily: 'Peddana', fontSize: 19),
            ),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Created by :- MUHAMMED BILAL A',
                    style: TextStyle(
                        color: whiteColor, fontFamily: 'Peddana', fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Contact Developer :-',
                          style: TextStyle(
                              color: whiteColor,
                              fontFamily: 'Peddana',
                              fontSize: 19),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://www.instagram.com/invites/contact/?i=tm2aejk5l8qs&utm_content=3e6y0ea');
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        },
                        child: SizedBox(
                          height: 23,
                          width: 23,
                          child: Image.asset(
                            'assets/images/instalogo2.png',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://t.me/+wcQaJGDYvKFlNjY1');
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        },
                        child: SizedBox(
                          height: 23,
                          width: 23,
                          child: Image.asset(
                            'assets/images/telegram1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'bilalmuhammed402@gmail.com',
                              query: encodeQueryParameters(<String, String>{
                                'subject': 'BlackBeatz related query',
                              }));
                          await launchUrl(emailLaunchUri);
                        },
                        child: SizedBox(
                          height: 27,
                          width: 27,
                          child: Image.asset(
                            'assets/images/email.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(
                              'https://www.linkedin.com/in/muhammed-bilal-36332a25b');
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        },
                        child: SizedBox(
                          height: 23,
                          width: 23,
                          child: Image.asset(
                            'assets/images/linkedin1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }
}

class DrawerlistCustom extends StatelessWidget {
  String title;
  var icon;
  DrawerlistCustom({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListTile(
        leading: Text(
          title,
          style: TextStyle(
            color: drawerlistTextColor,
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.height * 0.018,
            // fontSize: 16,
          ),
        ),
        trailing: FaIcon(
          icon,
          size: MediaQuery.of(context).size.height * 0.024,
          color: drawerlistTextColor,
        ),
      ),
    );
  }
}

notificationFunction(value) async {
  notification = value;
  Box<bool> notidb = await Hive.openBox('notification');
  notidb.add(value);
}
