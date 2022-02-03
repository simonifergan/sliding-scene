import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({Key? key}) : super(key: key);

  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AssetsAudioPlayer musicPlayer;

  @override
  void initState() {
    musicPlayer = AssetsAudioPlayer.withId("music-player-widget");
    musicPlayer
        .open(Audio.file("assets/sounds/music/purple_cat-crescent_moon.mp3"));
    super.initState();
  }

  @override
  void dispose() {
    musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Text("hi"),
      onTap: () {
        musicPlayer.playOrPause();
      },
    );
  }
}
