import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({Key? key}) : super(key: key);

  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AssetsAudioPlayer musicPlayer;
  bool isPlaying = false;
  @override
  void initState() {
    musicPlayer = AssetsAudioPlayer.withId("music-player-widget");
    musicPlayer.open(
        Audio.file("assets/sounds/music/purple_cat-crescent_moon.mp3"),
        autoStart: false,
        loopMode: LoopMode.single);
    super.initState();
  }

  void toggle() {
    musicPlayer.playOrPause();
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: toggle,
        icon: Icon(
            isPlaying ? Icons.volume_up_rounded : Icons.volume_off_rounded));
  }
}
