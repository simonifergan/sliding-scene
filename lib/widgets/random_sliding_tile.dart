import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rive/rive.dart';
import 'package:sliding_scene/interfaces/position.dart';

import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';

class RandomSlidingTile extends StatefulWidget {
  const RandomSlidingTile({Key? key}) : super(key: key);

  @override
  _RandomSlidingTileState createState() => _RandomSlidingTileState();
}

class _RandomSlidingTileState extends State<RandomSlidingTile> {
  int location = 1;
  late int visibleTile;
  late Timer _timer;

  int getTileNumber() {
    int nextNumber;
    do {
      nextNumber = Random().nextInt(15);
    } while (nextNumber == visibleTile);

    return nextNumber;
  }

  Position tilePosition = const Position(x: 2, y: 2);

  @override
  void initState() {
    visibleTile = 0;

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      int nextLocation = location + 1;
      if (nextLocation > 4) {
        nextLocation = 1;
      }

      int nextTile = getTileNumber();

      setState(() {
        location = nextLocation;
        visibleTile = nextTile;

        switch (nextLocation) {
          case 1:
            tilePosition = const Position(x: 2, y: 2);
            break;
          case 2:
            tilePosition = const Position(x: 1, y: 2);
            break;
          case 3:
            tilePosition = const Position(x: 1, y: 1);
            break;
          case 4:
            tilePosition = const Position(x: 2, y: 1);
            break;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, PuzzleState>(
        converter: (store) => store.state,
        builder: (context, PuzzleState state) => SizedBox.square(
              dimension: state.tileSize * 2,
              child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(15, (index) {
                    return AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: FractionalOffset(
                          tilePosition.x / 3, tilePosition.y / 3),
                      child: AnimatedOpacity(
                          opacity: index == visibleTile ? 1 : 0,
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeColors.lightBlue
                                          .withOpacity(0.6),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              width: state.tileSize,
                              height: state.tileSize,
                              child: RiveAnimation.asset(
                                'rive/windmill.riv',
                                artboard: (index + 1).toString(),
                                fit: BoxFit.fill,
                              ))),
                    );
                  })),
            ));
  }
}
