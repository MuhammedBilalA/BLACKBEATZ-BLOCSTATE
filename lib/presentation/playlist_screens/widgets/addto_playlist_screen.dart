import 'dart:async';


import 'package:black_beatz/application/playlist/playlist_bloc.dart';
import 'package:black_beatz/infrastructure/db_functions/playlist_functions/playlist_function.dart';
import 'package:black_beatz/domain/songs_db_model/songs_db_model.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/core/widgets/snackbar.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:black_beatz/presentation/playlist_screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddToPlaylist extends StatelessWidget {
  final Songs addToPlaylistSong;
  const AddToPlaylist({super.key, required this.addToPlaylistSong});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        body: BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            return Column(
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
                                        height:
                                            MediaQuery.of(context).size.height *
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
                            onChanged: (value) {
                              context.read<PlaylistBloc>().add(SearchPlaylist(
                                    query: value,
                                  ));
                              // log(value);
                            },
                            controller: _playlistSearchControllor,
                            decoration: InputDecoration(
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 25, right: 20),
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
                                    borderSide: const BorderSide(
                                        color: Colors.pinkAccent),
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
                (state.playList.isEmpty || state.searchPlaylist?.length == 0)
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
                        child: searchFoundcplaylist(
                            context,
                            addToPlaylistSong,
                            (_playlistSearchControllor.text.isEmpty ||
                                    _playlistSearchControllor.text
                                        .trim()
                                        .isEmpty)
                                ? state.playList
                                : state.searchPlaylist!),
                      )
              ],
            );
          },
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
                      for (var element in playListNotifier) {
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
                        // setState(() {});
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
                    onPressed: () async {
                      if (playlistFormkey.currentState!.validate()) {
                        List<EachPlaylist> playlistCreatingList =
                            await playlistCreating(playlistControllor.text);
                        context.read<PlaylistBloc>().add(
                            PlaylistEventClass(playList: playlistCreatingList));

                        // setState(() {});
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

  // searchPlaylist(String searchtext) {
  Widget searchFoundcplaylist(BuildContext context, Songs addToPlaylistSong,
      List<EachPlaylist> statePlaylist) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (statePlaylist[index]
                .container
                .contains(addToPlaylistSong)) {
              snackbarRemoving(text: 'song is alredy exist', context: context);
            } else {
              statePlaylist[index].container.add(addToPlaylistSong);
              playlistAddDB(
                  addToPlaylistSong, statePlaylist[index].name);
              snackbarAdding(
                  text: 'song added to ${statePlaylist[index].name}',
                  context: context);
            }
            Timer(const Duration(milliseconds: 900), () {
              Navigator.of(context).pop();
            });
          },
          child: PlaylistSearchTile(
            title: statePlaylist[index].name,
            context: context,
            index: index,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemCount: statePlaylist.length,
    );
  }
}

ValueNotifier<List<EachPlaylist>> playlistSearchNotifier = ValueNotifier([]);
TextEditingController _playlistSearchControllor = TextEditingController();

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
