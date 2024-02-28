import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song_model.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  List<Song> songs = Song.songs;

  int _currentIndex = 0;
  Song _currentSong = Song.songs[0];
  bool _loopMode = false;

  Song get currentSong => _currentSong;
  int get currentIndex => _currentIndex;
  bool get loopMode => _loopMode;
  Future<void> update(Song song, newIndex) async {
    // Stop any previously playing song

    if (_currentIndex != newIndex || !player.playing) {
      await player.stop();
      _currentIndex = newIndex;
      _currentSong = song;
      notifyListeners();
      await player
          .setAudioSource(AudioSource.uri(Uri.parse('asset:///${song.url}')));
      await player.play();

      notifyListeners();
    } else if (!player.playing) {
      await player
          .setAudioSource(AudioSource.uri(Uri.parse('asset:///${song.url}')));
      await player.play();
      notifyListeners();
    }
  }

  Future<void> loopModeUpdate(Song song, bool loop) async {
    _loopMode = loop;
    notifyListeners();
  }

  Future<void> seekAudio(value) async {
    int seconds = value.toInt();
    await player.seek(Duration(seconds: seconds));
    print(value);
    print('i am here');
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
