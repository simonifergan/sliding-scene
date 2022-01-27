import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayPauseAnimation extends StatefulWidget {
  const PlayPauseAnimation({Key? key}) : super(key: key);

  @override
  _PlayPauseAnimationState createState() => _PlayPauseAnimationState();
}

class _PlayPauseAnimationState extends State<PlayPauseAnimation> {
  // Controller for playback
  late RiveAnimationController _controller;

  // Toggles between play and pause animation states

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _controller.isActive;

  void callTimer(Timer _) {
    setState(() {
      _controller.isActive = !_controller.isActive;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Rotate');
    _controller.isActive = false;
    Timer.periodic(const Duration(seconds: 1), callTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'rive/weirdship.riv',
          controllers: [_controller],

          // Update the play state when the widget's initialized
          onInit: (_) => setState(() {}),
        ),
      ),
    );
  }
}
