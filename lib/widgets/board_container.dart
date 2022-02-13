import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu/menu.dart';

class BoardContainer extends StatefulWidget {
  const BoardContainer({Key? key}) : super(key: key);

  @override
  State<BoardContainer> createState() => _BoardContainerState();
}

class _BoardContainerState extends State<BoardContainer> {
  List<double> fromStops = [0.10, 0.90];
  List<double> toStops = [0.30, 0.80];
  bool isReversed = false;
  late Timer animationTicker;
  @override
  void initState() {
    animationTicker = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (StoreProvider.of<PuzzleState>(context).state.gameStatus ==
          GameStatus.playing) {
        setState(() {
          isReversed = !isReversed;
        });
        return;
      }

      setState(() {
        isReversed = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    animationTicker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: const Key("puzzle-game-animated-container"),
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
          gradient: RadialGradient(
        center: const Alignment(0, 0),
        stops: isReversed ? fromStops : toStops,
        radius: 1.0,
        colors: const [
          Color(0xFFd86f6b),
          Color(0xFF0b1b28),
        ],
      )),
      child: Column(children: const [
        SafeArea(
            child: Menu(
          key: Key("game-menu"),
        )),
        Board(
          key: Key("board"),
        ),
      ]),
    );
  }
}
