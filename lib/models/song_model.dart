import 'package:flutter/foundation.dart';

class Song extends ChangeNotifier {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
    Song(
      title: 'Glass',
      description: 'Glass',
      url: 'assets/music/glass.mp3',
      coverUrl: 'assets/images/glass.jpg',
    ),
    Song(
      title: 'Illusions',
      description: 'Illusions',
      url: 'assets/music/illusions.mp3',
      coverUrl: 'assets/images/illusions.jpg',
    ),
    Song(
      title: 'Pray',
      description: 'Pray',
      url: 'assets/music/pray.mp3',
      coverUrl: 'assets/images/pary.jpg',
    ),
    Song(
      title: 'Moy',
      description: 'Baratindian singer',
      url: 'assets/music/moye_moye.mp3',
      coverUrl: 'assets/images/moye.jpg',
    ),
    Song(
      title: 'Safwan',
      description: 'Safwan sounth indian singer',
      url: 'assets/music/saf1.mp3',
      coverUrl: 'assets/images/saf1.jpg',
    ),
    Song(
      title: 'guit',
      description: 'Glass',
      url: 'assets/music/glass.mp3',
      coverUrl: 'assets/images/guit.jpg',
    ),
    Song(
      title: 'tesr',
      description: 'Illusions',
      url: 'assets/music/illusions.mp3',
      coverUrl: 'assets/images/guitar.jpg',
    ),
  ];
}
