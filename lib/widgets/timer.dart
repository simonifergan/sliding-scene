import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

class _ViewModel {
  _ViewModel({required this.gameStatus, required this.startTime});

  final GameStatus gameStatus;
  final DateTime? startTime;
}

class GameSessionTimer extends StatefulWidget {
  const GameSessionTimer({Key? key}) : super(key: key);

  @override
  _GameSessionTimerState createState() => _GameSessionTimerState();
}

class _GameSessionTimerState extends State<GameSessionTimer> {
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String getTimeDiff(DateTime startTime) {
    final duration = Duration(seconds: startTime.second);
    final hours = _twoDigits(duration.inHours);
    final minutes = _twoDigits(duration.inMinutes.remainder(60));
    final seconds = _twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void tick(timer) {
    print("hi");
    setState(() {});
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), tick);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
        converter: (store) => _ViewModel(
            gameStatus: store.state.gameStatus,
            startTime: store.state.startTime),
        builder: (context, viewModel) {
          if (viewModel.gameStatus != GameStatus.playing ||
              viewModel.startTime == null) {
            return const SizedBox();
          }

          return Text(getTimeDiff(viewModel.startTime!));
        });
  }
}
