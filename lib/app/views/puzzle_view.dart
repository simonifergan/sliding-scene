import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu/menu.dart';

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      StoreProvider.of<PuzzleState>(context).dispatch(
          PuzzleAction(type: PuzzleActions.setTileSize, payload: constraints));

      return Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          center: Alignment(0, 0),
          stops: [
            0.10,
            0.90,
          ],
          radius: 1.0,
          colors: [
            Color(0xFFd86f6b),
            Color(0xFF0b1b28),
          ],
        )),
        child: Column(children: const [
          SafeArea(child: Menu()),
          Board(),
        ]),
      );
    });
  }
}
