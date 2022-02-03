import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, PuzzleState>(
        converter: (store) => store.state,
        builder: (context, puzzleState) => Text(
            puzzleState.gameStatus == GameStatus.done ? "Done" : "Playing"));
  }
}
