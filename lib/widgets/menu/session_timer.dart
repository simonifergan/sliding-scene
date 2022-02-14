import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliding_scene/services/puzzle_service.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer(
      {Key? key, required this.secondsElpased, required this.gameStatus})
      : super(key: key);

  final Duration secondsElpased;
  final GameStatus gameStatus;

  @override
  _SessionTimerState createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
  late Duration duration;
  late Timer timer;
  late DateTime secondsElpased;
  late bool isActive;

  String _formatTimer() {
    final hours = _twoDigits(duration.inHours);
    final minutes = _twoDigits(duration.inMinutes.remainder(60));
    final seconds = _twoDigits(duration.inSeconds.remainder(60));
    return " $hours:$minutes:$seconds ";
  }

  void tick(timer) {
    setState(() {
      duration = Duration(seconds: duration.inSeconds + 1);
    });
  }

  void initTicker() {
    setState(() {
      isActive = true;
      duration = Duration(seconds: widget.secondsElpased.inSeconds);
      timer = Timer.periodic(const Duration(seconds: 1), tick);
    });
  }

  @override
  void initState() {
    initTicker();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionTimer oldWidget) {
    // implement here logic for game is done.
    final gameStatus = widget.gameStatus;
    if (gameStatus == GameStatus.playing && !isActive) {
      initTicker();
    } else if (gameStatus == GameStatus.done) {
      timer.cancel();
      setState(() {
        isActive = false;
      });
    } else if (gameStatus != GameStatus.playing) {
      timer.cancel();
      setState(() {
        isActive = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 100,
          margin: const EdgeInsets.only(right: 2),
          child: Text(
            _formatTimer(),
            style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
        const Icon(
          Icons.timer,
          color: Colors.white,
        )
      ],
    );
  }
}
