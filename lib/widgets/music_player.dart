import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget(
      {Key? key, required this.fileName, required this.sound})
      : super(key: key);

  final String fileName;
  final bool sound;
  @override
  _MusicPlayerWidgetState createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AssetsAudioPlayer musicPlayer;
  late bool isActive = false;

  @override
  void initState() {
    musicPlayer = AssetsAudioPlayer.withId("music-player-widget");
    musicPlayer.open(Audio.file("assets/sounds/music/${widget.fileName}"),
        autoStart: widget.sound, loopMode: LoopMode.single, volume: 0.4);

    isActive = widget.sound;
    super.initState();
  }

  void toggle() async {
    if (isActive) {
      await musicPlayer.stop().then((_) => musicPlayer.seek(Duration.zero));
    } else {
      await musicPlayer.play();
    }

    StoreProvider.of<PuzzleState>(context).dispatch(
        PuzzleAction(type: PuzzleActions.setSound, payload: !isActive));
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  void dispose() async {
    await musicPlayer.stop();
    await musicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: toggle,
      child: Icon(
        isActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
