import 'package:flutter/material.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu.dart';

// Color(0xFF0B1B28),
//   Color(0xFF1A3245),
//   Color(0xFF294862),
//   Color(0xFF385F7F),
//   Color(0xFF47759C),
//   Color(0xFF568CB9),
//   Color(0xFF65A2D6),
//   Color(0xFF65A2D6),
//   Color(0xFF568CB9),
//   Color(0xFF47759C),
//   Color(0xFF385F7F),
//   Color(0xFF294862),
//   Color(0xFF1A3245),
//   Color(0xFF0B1B28),
class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF2b3058),
        child: Row(
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
          ],
        ));
  }
}
