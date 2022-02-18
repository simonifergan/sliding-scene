import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({
    Key? key,
    required this.song,
  }) : super(key: key);

  final String song;

  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AssetsAudioPlayer musicPlayer;
  bool isPlaying = true;

  @override
  void initState() {
    musicPlayer = AssetsAudioPlayer.withId("music-player-widget");
    musicPlayer.open(Audio.file("assets/sounds/music/${widget.song}"),
        autoStart: false, loopMode: LoopMode.single);

    super.initState();
  }

  void toggle() {
    musicPlayer.playOrPause();
    StoreProvider.of<PuzzleState>(context).dispatch(
        PuzzleAction(type: PuzzleActions.setSound, payload: !isPlaying));
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
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: toggle,
      child: Icon(
        isPlaying ? Icons.volume_up_rounded : Icons.volume_off_rounded,
        color: ThemeColors.yellow,
        size: 30,
      ),
    );
  }
}
