import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/menu/menu.dart';
import 'package:sliding_scene/widgets/music_player.dart';
import 'package:sliding_scene/widgets/preview.dart';
import 'package:sliding_scene/widgets/start_game_button.dart';

class PuzzleView extends StatefulWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  State<PuzzleView> createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  List<double> fromStops = [0.10, 0.90];
  List<double> toStops = [0.30, 0.70];
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
    return LayoutBuilder(builder: (context, constraints) {
      StoreProvider.of<PuzzleState>(context).dispatch(
          PuzzleAction(type: PuzzleActions.setTileSize, payload: constraints));

      final tileSize = StoreProvider.of<PuzzleState>(context).state.tileSize;

      return Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
              gradient: RadialGradient(
            center: const Alignment(0, 0),
            stops: isReversed ? fromStops : toStops,
            radius: 1.0,
            colors: [ThemeColors.red, ThemeColors.darkBlue],
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tileSize > ResponseTileSize.medium
                ? [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        StartGameButton(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SafeArea(child: Menu()),
                            Board(),
                          ]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: MusicPlayerWidget(),
                          ),
                          PreviewButton()
                        ])
                      ],
                    ),
                  ]
                : [
                    Column(children: [
                      const SafeArea(
                          child: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Menu(),
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: tileSize * 2),
                        child: const Board(),
                      ),
                    ]),
                  ],
          ),
        ),
      );
    });
  }
}
