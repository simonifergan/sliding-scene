import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';
import 'package:hackathon_slide_puzzle/widgets/board.dart';

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Column(
          children: [
            Row(children: [
              GestureDetector(
                  onTap: () {
                    StoreProvider.of<PuzzleState>(context).dispatch(
                        PuzzleAction(
                            type: PuzzleActions.shuffleBoard, payload: null));
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    width: tileSize * 2,
                    height: tileSize * 2,
                  ))
            ]),
          ],
        ),
        const Center(
          child: Board(),
        )
      ]),
    );
  }
}
