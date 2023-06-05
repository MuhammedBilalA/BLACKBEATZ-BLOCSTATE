import 'package:black_beatz/infrastructure/db_functions/playlist_functions/playlist_function.dart';
import 'package:black_beatz/core/colors/colors.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_class.dart';
import 'package:black_beatz/presentation/playlist_screens/widgets/playlist_unique_screen.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaylistScreen extends StatelessWidget {
   PlaylistScreen({super.key});

  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColorLight,
      appBar: AppBar(
        backgroundColor: backgroundColorLight,
        title: const Text(
          'PLAYLIST',
          style: TextStyle(
              height: 3,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {
                  createNewPlaylist(context);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.plus,
                  size: 26,
                )),
          )
        ],
      ),

      // --------------------------------Body Starting------------------------
      body: ValueListenableBuilder(
        valueListenable: playlistBodyNotifier,
        builder: (context, value, child) => (playListNotifier.value.isEmpty)
            ? emptyPlaylist()
            : gridViewBuilderBody(),
      ),
    );
  }

  Center emptyPlaylist() {
    return const Center(
      child: Text(
        'Add New Playlist',
        style: TextStyle(
            color: Color.fromARGB(227, 255, 255, 255),
            fontFamily: 'Peddana',
            fontSize: 26),
      ),
    );
  }

  ValueListenableBuilder<dynamic> gridViewBuilderBody() {
    return ValueListenableBuilder(
      valueListenable: playlistBodyNotifier,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: playListNotifier.value.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => PlaylistUniqueScreen(
                          playlist: playListNotifier.value[index],
                        )));
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/playlistimagesqure.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 0) {
                              renamefunction(context, index);
                            } else {
                              deleteplaylistfunction(index,context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: backgroundColorDark,
                          icon: const FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: whiteColor,
                            size: 26,
                          ),
                          itemBuilder: (context) => [
                                //---------Edit Playlist--------------
                                const PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Edit Playlist',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Peddana',
                                            height: 0.6,
                                            fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: whiteColor,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                                //---------Delete playlist---------
                                const PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delete Playlist',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Peddana',
                                            height: 0.6,
                                            fontSize: 17),
                                      ),
                                      Icon(
                                        Icons.delete_forever,
                                        color: whiteColor,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                )
                              ])),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.466,
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Color.fromARGB(209, 25, 0, 41),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 8),
                        child: Text(
                          playListNotifier.value[index].name,
                          style: const TextStyle(
                              height: 1,
                              color: whiteColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Peddana'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> createNewPlaylist(BuildContext context) {
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

  deleteplaylistfunction(int index,BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: alertDialogBackgroundColor,
            title: const Text(
              'Are you sure you want to delete',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
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
                    onPressed: () {
                     
                        playlistdelete(index);
                        Navigator.of(ctx).pop();

                        playlistBodyNotifier.notifyListeners();
                      
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

// -----------Rename Function Here------------------------
  renamefunction(BuildContext context, int index) {
    TextEditingController rename = TextEditingController();

    rename.text = playListNotifier.value[index].name;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: alertDialogBackgroundColor,
            content: const Text(
              'Rename Playlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
              Form(
                key: playlistFormkey,
                child: TextFormField(
                  maxLength: 15,
                  controller: rename,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name is requiered';
                    } else {
                      for (var element in playListNotifier.value) {
                        if (element.name == rename.text) {
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
                     
                          // ---renaming the playlist

                          playlistrename(index, rename.text);
                        
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
}

// ----playlistBodyNotifier for rebuilding the playlist body
ValueNotifier playlistBodyNotifier = ValueNotifier([]);

// ----playlistNotifier for  creating playlist objects and its contain the playlist name and container
ValueNotifier<List<EachPlaylist>> playListNotifier = ValueNotifier([]);

final playlistFormkey = GlobalKey<FormState>();
TextEditingController playlistControllor = TextEditingController();
