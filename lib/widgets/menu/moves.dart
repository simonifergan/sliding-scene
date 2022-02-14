import 'package:flutter/material.dart';
import 'package:sliding_scene/styles/menu_text.dart';

class Moves extends StatelessWidget {
  const Moves({Key? key, required this.moves}) : super(key: key);
  final int moves;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Moves: ",
          style: MenuTextStyle(),
        ),
        Text(moves.toString(), style: const MenuTextStyle(bold: false))
      ],
    );
  }
}
