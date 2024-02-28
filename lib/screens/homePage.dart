import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musci_app/models/song_model.dart';
import 'package:musci_app/screens/songList.dart';

import '../providers/audioPlayerProvider.dart';
import 'musicDetail.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = Song.songs;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayerProvider>(context, listen: true);
    // final _currentSong = audioPlayer.currentSong;
    final _player = audioPlayer.player;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text('Music')),
      //   actions: const [],elevation: 0,
      // ),
      drawer: const Drawer(),
      backgroundColor: const Color.fromARGB(255, 217, 203, 219),
      body: Column(
        children: [
          Stack(
            children: [
              Consumer<AudioPlayerProvider>(
                  builder: (context, audioPlayerNew, child) {
                return Container(
                  alignment: Alignment.topCenter,
                  height: 250,
                  decoration:  BoxDecoration(
                    // color: Colors.amber,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(55),
                    ),
                    image: DecorationImage(
                      image: AssetImage(audioPlayerNew.currentSong.coverUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
              Container(
                margin: const EdgeInsets.only(top: 180, left: 10, right: 10),
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Consumer<AudioPlayerProvider>(
                  builder: (context, audioPlayerNew, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                    audioPlayerNew.currentSong.coverUrl),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  audioPlayerNew.currentSong.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                    color: Color.fromARGB(255, 41, 19, 100),
                                  ),
                                ),
                                Text(
                                  audioPlayerNew.currentSong.description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 41, 19, 100),
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 156, 6, 194),
                                      width: 3),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: StreamBuilder(
                                stream: _player!.playerStateStream,
                                builder: (context, snapshot) {
                                  final processingState =
                                      snapshot.connectionState;
                                  final playbackState = snapshot.data;
                                  if (processingState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (playbackState!.playing) {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.pause_circle_filled_outlined,
                                        size: 30,
                                        color: Color.fromARGB(255, 156, 6, 194),
                                      ),
                                      onPressed: () {
                                        _player.pause();
                                      },
                                    );
                                  } else {
                                    return IconButton(
                                      icon: const Icon(
                                        Icons.play_circle_fill_outlined,
                                        size: 30,
                                        color: Color.fromARGB(255, 156, 6, 194),
                                      ),
                                      onPressed: () {
                                        // _player.play();

                                        audioPlayer.update(
                                          audioPlayerNew.currentSong,
                                          audioPlayerNew.currentIndex,
                                        );
                                      },
                                    );
                                  }
                                },
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Container(
                  width: 365,
                  margin: const EdgeInsetsDirectional.only(top: 20),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.3), // Partially transparent white
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      audioPlayer.update(songs[index], index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MusicDetail(song: songs[index], songIndex: index),
                        ),
                      );
                    },
                    child: SongContainer(song: songs[index]));
              },
            ),
          )
        ],
      ),
    );
  }
}

class SongContainer extends StatelessWidget {
  const SongContainer({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 190,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage(song.coverUrl),
                fit: BoxFit.fill,
                width: 180,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  song.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 41, 19, 100),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '208',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Color.fromARGB(255, 41, 19, 100),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Icon(
                      Icons.play_circle_filled_outlined,
                      color: Colors.pinkAccent,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
