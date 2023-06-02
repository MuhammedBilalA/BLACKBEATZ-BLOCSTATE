import 'dart:async';

import 'package:black_beatz/database/playlist/playlist_function/playlist_function.dart';
import 'package:black_beatz/database/songs/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/screens/common_widgets/snackbar.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_class.dart';
import 'package:black_beatz/screens/playlist_screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddToPlaylist extends StatefulWidget {
  final Songs addToPlaylistSong;
  const AddToPlaylist({super.key, required this.addToPlaylistSong});

  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

ValueNotifier<List<EachPlaylist>> playlistSearchNotifier = ValueNotifier([]);
TextEditingController _playlistSearchControllor = TextEditingController();

class _AddToPlaylistState extends State<AddToPlaylist> {
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

    return Scaffold(
      backgroundColor: backgroundColorLight,
      appBar: AppBar(
        backgroundColor: backgroundColorLight,
        title: Text(
          'ADD TO PLAYLIST',
          style: TextStyle(
              height: MediaQuery.of(context).size.height * 0.0030,
              fontFamily: 'Peddana',
              fontWeight: FontWeight.w600,
              fontSize: 25),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
                child: FaIcon(
              FontAwesomeIcons.angleLeft,
            ))),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // -------------------------------------------
                          createNewplaylistForAddToPlaylist(context);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: backgroundColorDark,
                          ),
                          child: Center(
                            child: Text(
                              'NEW PLAYLIST',
                              style: TextStyle(
                                  height: MediaQuery.of(context).size.height *
                                      0.0023,
                                  fontFamily: 'Peddana',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ----------------Search-------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (value) => searchPlaylist(value),
                      controller: _playlistSearchControllor,
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 25, right: 20),
                            child: FaIcon(
                              FontAwesomeIcons.searchengin,
                              size: 30,
                              color: Color(0xFFC0C0C0),
                            ),
                          ),
                          fillColor: whiteColor.withOpacity(.3),
                          filled: true,
                          hintText: 'Find Playlist',
                          hintStyle: const TextStyle(
                              color: Color(0xFFC0C0C0),
                              fontFamily: 'Peddana',
                              height: .5,
                              fontSize: 25),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.pinkAccent),
                              borderRadius: BorderRadius.circular(30)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  ),
                ),
                // ----------------Search-------------
              ],
            ),
          ),
          (playListNotifier.value.isEmpty)
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Create New Playlist',
                      style: TextStyle(
                          color: Color.fromARGB(227, 255, 255, 255),
                          fontFamily: 'Peddana',
                          fontSize: 20),
                    ),
                  ),
                )
              : Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: playlistSearchNotifier,
                    builder: (context, value, child) =>
                        _playlistSearchControllor.text.isEmpty ||
                                _playlistSearchControllor.text.trim().isEmpty
                            ? searchFunctionplaylist(
                                context, widget.addToPlaylistSong)
                            : playlistSearchNotifier.value.isEmpty
                                ? searchEmptyPlaylist()
                                : searchFoundcplaylist(
                                    context, widget.addToPlaylistSong),
                  ),
                )
        ],
      ),
    );
  }

  Future<dynamic> createNewplaylistForAddToPlaylist(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: alertDialogBackgroundColor,
            content: const Text(
              'Create New Playlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
              Form(
                key: playlistFormkey,
                child: TextFormField(
                  maxLength: 15,
                  controller: playlistControllor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name is requiered';
                    } else {
                      for (var element in playListNotifier.value) {
                        if (element.name == playlistControllor.text) {
                          return 'name is alredy exist';
                        }
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Playlist Name',
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
                        setState(() {});
                        playlistControllor.text = '';
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
                    onPressed: () {
                      if (playlistFormkey.currentState!.validate()) {
                        playlistCreating(playlistControllor.text);

                        setState(() {});
                        playlistControllor.text = '';
                        Navigator.of(ctx).pop();
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

  Widget searchEmptyPlaylist() {
    return const SizedBox(
      child: Center(
        child: Text(
          'Playlist Not Found',
          style: TextStyle(
              fontSize: 25,
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Peddana'),
        ),
      ),
    );
  }

  searchPlaylist(String searchtext) {
    playlistSearchNotifier.value = playListNotifier.value
        .where(
            (element) => element.name.contains(searchtext.toLowerCase().trim()))
        .toList();
  }

  Widget searchFunctionplaylist(BuildContext context, Songs addToPlaylistSong) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          width: screenWidth,
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 600 + (index * 200)),
          transform:
              Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
          child: InkWell(
            onTap: () {
              if (playListNotifier.value[index].container
                  .contains(widget.addToPlaylistSong)) {
                snackbarRemoving(
                    text: 'song is alredy exist', context: context);
              } else {
                playListNotifier.value[index].container
                    .add(widget.addToPlaylistSong);
                playlistAddDB(widget.addToPlaylistSong,
                    playListNotifier.value[index].name);

                snackbarAdding(
                    text: 'song added to ${playListNotifier.value[index].name}',
                    context: context);
              }

              Timer(const Duration(milliseconds: 900), () {
                playlistBodyNotifier.notifyListeners();
                Navigator.of(context).pop();
              });
            },
            child: PlaylistSearchTile(
              title: playListNotifier.value[index].name,
              context: context,
              index: index,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemCount: playListNotifier.value.length,
    );
  }

  Widget searchFoundcplaylist(BuildContext context, Songs addToPlaylistSong) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (playlistSearchNotifier.value[index].container
                .contains(widget.addToPlaylistSong)) {
              snackbarRemoving(text: 'song is alredy exist', context: context);
            } else {
              playlistSearchNotifier.value[index].container
                  .add(widget.addToPlaylistSong);
              playlistAddDB(widget.addToPlaylistSong,
                  playlistSearchNotifier.value[index].name);
              snackbarAdding(
                  text:
                      'song added to ${playlistSearchNotifier.value[index].name}',
                  context: context);
            }
            Timer(const Duration(milliseconds: 900), () {
              Navigator.of(context).pop();
            });
          },
          child: PlaylistSearchTile(
            title: playlistSearchNotifier.value[index].name,
            context: context,
            index: index,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemCount: playlistSearchNotifier.value.length,
    );
  }
}

// --------------------Its Just A List tile -------------------
class PlaylistSearchTile extends StatelessWidget {
  int index;
  BuildContext context;
  var title;

  PlaylistSearchTile({
    super.key,
    required this.index,
    required this.context,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              colors: [
                Color.fromARGB(255, 1, 2, 9),
                Color.fromARGB(255, 6, 16, 157),
                Color.fromARGB(255, 42, 2, 87),
              ],
            ),
          ),
          height: 85,
          child: Row(
            children: [
              const Spacer(
                flex: 1,
              ),
              Container(
                height: 70,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/playlistimagesqure.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontFamily: 'Peddana',
                    fontSize: 30,
                    height: 1.5,
                    color: whiteColor,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(
                flex: 6,
              )
            ],
          ),
        ),
      ),
    );
  }
}
