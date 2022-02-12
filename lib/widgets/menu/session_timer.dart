import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer({Key? key, required this.startTime}) : super(key: key);
  final DateTime? startTime;

  @override
  _SessionTimerState createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
  late Duration duration;
  late Timer timer;

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

  @override
  void initState() {
    duration = Duration(seconds: widget.startTime!.second);
    timer = Timer.periodic(const Duration(seconds: 1), tick);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.startTime != null
        ? Row(
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
          )
        : const SizedBox();
  }
}
