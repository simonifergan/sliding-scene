import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

class GameSessionTimer extends StatelessWidget {
  const GameSessionTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, List<dynamic>>(
        converter: (store) => [store.state.startTime, store.state.gameStatus],
        builder: (context, state) => state[1] == GameStatus.playing
            ? Text(state[0].toLocal().toString())
            : const SizedBox());
  }
}
