import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu.dart';

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      StoreProvider.of<PuzzleState>(context).dispatch(
          PuzzleAction(type: PuzzleActions.setTileSize, payload: constraints));

      return Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Menu(key: Key("menu")),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Board(),
                  ]),
              Column(
                children: const [],
              ),
            ],
          ));
    });
  }
}
