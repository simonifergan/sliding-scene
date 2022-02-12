import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu/menu.dart';

class PuzzleView extends StatefulWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  State<PuzzleView> createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  List<double> fromStops = [0.10, 0.90];
  List<double> toStops = [0.20, 0.80];
  bool isReversed = false;
  late Timer animationTicker;
  @override
  void initState() {
    animationTicker = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        isReversed = !isReversed;
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
    return LayoutBuilder(builder: (context, constraints) {
      StoreProvider.of<PuzzleState>(context).dispatch(
          PuzzleAction(type: PuzzleActions.setTileSize, payload: constraints));

      return AnimatedContainer(
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
          SafeArea(child: Menu()),
          Board(),
        ]),
      );
    });
  }
}
