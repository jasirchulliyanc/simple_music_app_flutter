import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musci_app/models/song_model.dart';
import 'package:rxdart/rxdart.dart';

import '../providers/audioPlayerProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key, required this.song, required this.songIndex});
  final Song song;
  final int songIndex;
  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail> {
  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      // Use the _player retrieved from Provider consistently
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .player
              .positionStream,
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .player
              .bufferedPositionStream,
          Provider.of<AudioPlayerProvider>(context, listen: false)
              .player
              .durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    final audioPlayer =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      // backgroundColor: AppColor.mix1,
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [Color(0xffcc2b5e), Color(0xff2e073b)],
            stops: [0.5, 1],
            center: Alignment.bottomLeft,
          ),
        ),
        child: Consumer<AudioPlayerProvider>(
          builder: (context, audioPlayerNew, child) {
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 100),
                    height: 350,
                    width: 300,
                    decoration: BoxDecoration(
                      // color: Colors.amber,
                      // borderRadius: BorderRadius.circular(20)
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(75),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          audioPlayerNew.currentSong.coverUrl,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    audioPlayerNew.currentSong.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),

                //  ControlButtons(_player),
                Align(
                  child: StreamBuilder(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final positionData = snapshot.data;
                        final durationInSeconds =
                            positionData!.duration.inSeconds.toDouble();
                        final positionInSeconds =
                            positionData!.position.inSeconds.toDouble();
                        return Slider(
                          min: 0,
                          max: durationInSeconds,
                          value: positionInSeconds,
                          activeColor: const Color.fromARGB(255, 221, 6, 192),
                          // inactiveColor: Colors.orange,
                          allowedInteraction: SliderInteraction.slideThumb,
                          onChanged: (value) {
                            audioPlayer.seekAudio(value);
                          },
                          onChangeEnd: (value) {
                          },
                        );
                      } else {
                        return Slider(
                          min: 0,
                          max: 0,
                          value: 0,
                          activeColor: const Color.fromARGB(255, 221, 6, 192),
                          onChanged: (value) {},
                        );
                      }
                    },
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PlayButton(audioPlayer, audioPlayerNew.currentIndex),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PlayButton extends StatelessWidget {
  final audioPlayer;
  final int songIndex;

  List<Song> songs = Song.songs;
  PlayButton(this.audioPlayer, this.songIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer player = audioPlayer.player;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shuffle,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            print(player.playing);
            // setState(() {
            //   isShuffling = !isShuffling;
            // });
          },
        ),
        const SizedBox(
          width: 15,
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            final int newIndex =
                songIndex != 0 ? songIndex - 1 : songs.length - 1;
            final Song newSong = songs[newIndex];
            audioPlayer.update(newSong, newIndex);
          },
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: StreamBuilder<PlayerState>(
            stream: player!.playerStateStream,
            builder: (context, snapshot) {
              final processingState = snapshot.connectionState;
              final playbackState = snapshot.data;

              if (processingState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!playbackState!.playing) {
                return IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill_outlined,
                    color: Color.fromARGB(255, 86, 8, 122),
                    size: 45,
                  ),
                  onPressed: () {
                    player.play();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(
                    Icons.pause,
                    color: Color.fromARGB(255, 86, 8, 122),
                    size: 45,
                  ),
                  onPressed: () => player!.pause(),
                );
              }
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            final int newIndex =
                songIndex != (songs.length - 1) ? songIndex + 1 : 0;
            final Song newSong = songs[newIndex];
            audioPlayer.update(newSong, newIndex);
          },
        ),
        const SizedBox(
          width: 15,
        ),
        IconButton(
          icon: Icon(
            Icons.repeat,
            color: audioPlayer.loopMode ? Colors.red : Colors.white,
            size: 30,
          ),
          onPressed: () {
            final Song newSong = songs[songIndex];
            bool newLoop = audioPlayer.loopMode ? false : true;
            print('newLoop');
            print(newLoop);
            audioPlayer.loopModeUpdate(newSong, newLoop);
            // setState(
            //   () {
            //     isRepeating = !isRepeating;
            //   },
            // );
          },
        ),
      ],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData(this.position, this.bufferedPosition, this.duration);
}
