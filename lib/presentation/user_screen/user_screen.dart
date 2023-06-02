import 'package:black_beatz/main.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/welcome_screens/welcomescreen_2.dart';
import 'package:black_beatz/presentation/favourite_screens/favourite.dart';
import 'package:black_beatz/presentation/mostly_played/mostly_played.dart';
import 'package:black_beatz/presentation/playing_screen/mini_player.dart';
import 'package:black_beatz/presentation/playlist_screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

final usernameFormkey = GlobalKey<FormState>();

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    if (currentlyplaying != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showBottomSheet(
            backgroundColor: transparentColor,
            context: context,
            builder: (context) => const MiniPlayer());
      });
    }
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: FutureBuilder(
                  future: getName(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Text(
                        '',
                        style: TextStyle(
                            color: whiteColor,
                            fontFamily: 'Peddana',
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      );
                    } else {
                      return Text(
                        snapshot.data!.toUpperCase(),
                        style: const TextStyle(
                            color: whiteColor,
                            fontFamily: 'Peddana',
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      );
                    }
                  }),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: ClipOval(
                        child: Image.asset(
                      'assets/images/music_on_world_off.jpg',
                      width: MediaQuery.of(context).size.width * 0.65,
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      editYourName(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFA416FB),
                          borderRadius: BorderRadius.circular(20)),
                      height: 38,
                      width: MediaQuery.of(context).size.width * 0.36,
                      child: const Center(
                          child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const FavouriteScreen()));
                },
                child: UserWidgets(
                    image: 'assets/images/oris.png',
                    title: 'MY FAVOURITES',
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFFA416FB),
                      size: 34,
                    ),
                    context: context),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const PlaylistScreen()));
              },
              child: UserWidgets(
                  image: 'assets/images/marshmelllow1.jpg',
                  title: 'MY PLAYLIST',
                  icon: const Icon(
                    Icons.playlist_add,
                    color: Color(0xFFA416FB),
                    size: 34,
                  ),
                  context: context),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const MostlyPlayed()));
              },
              child: UserWidgets(
                  image: 'assets/images/aura.png',
                  title: 'TOP BEATS',
                  icon: const Icon(
                    Icons.av_timer,
                    color: Color(0xFFA416FB),
                    size: 34,
                  ),
                  context: context),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 45),
                child: Text(
                  'VERSION 1.0.1',
                  style: TextStyle(
                      color: versionTextColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> editYourName(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: alertDialogBackgroundColor,
            content: const Text(
              'Edit Your Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
              Form(
                key: usernameFormkey,
                child: TextFormField(
                  controller: userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name is requiered';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mode_edit_outline_rounded,
                        size: 30,
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: redColor),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                          )),
                      child: const Text('Cancel'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (usernameFormkey.currentState!.validate()) {
                        setState(() {});
                        final sharedPrefs =
                            await SharedPreferences.getInstance();
                        await sharedPrefs.setString(
                            saveKeyName, userNameController.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 21,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                        )),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Future<String> getName() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final userLoggedIn = sharedPrefs.getString(saveKeyName);
  return userLoggedIn!;
}

class UserWidgets extends StatelessWidget {
  final String image;
  final String title;
  final Icon icon;
  final BuildContext context;

  const UserWidgets(
      {super.key,
      required this.image,
      required this.title,
      required this.icon,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 11),
      child: SizedBox(
        height: 69,
        width: MediaQuery.of(context).size.width * 1,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.53,
              child: Text(
                title,
                style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                    fontFamily: 'Peddana'),
              ),
            ),
          ),
          Expanded(child: icon)
        ]),
      ),
    );
  }
}
