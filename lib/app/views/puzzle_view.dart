import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/music_service.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';
import 'package:sliding_scene/widgets/back_to_menu_button.dart';
import 'package:sliding_scene/widgets/board.dart';
import 'package:sliding_scene/widgets/game_completion_dialog.dart';
import 'package:sliding_scene/widgets/leaderboards.dart';
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
  final List<double> fromStops = [0.10, 0.90];
  final List<double> toStops = [0.30, 0.70];
  bool isReversed = false;
  late Timer animationTicker;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    animationTicker.cancel();
    super.dispose();
  }

  final GameCompletionDialog gameCompletiondialog = const GameCompletionDialog(
    key: Key("game-completion-dialog"),
  );

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of<PuzzleState>(context).state;
    final sound = state.sound;
    final tileSize = state.tileSize;
    final gameStatus = state.gameStatus;

    return Stack(
      children: [
        WithResponsiveLayout(
          child: Material(
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
                    children: [
                      ...tileSize < ResponseTileSize.medium
                          ? [
                              Column(children: [
                                const SafeArea(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Menu(),
                                )),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, tileSize * 2, 0, 50),
                                    child: const Board(),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MusicPlayerWidget(
                                      key: const Key("music-widget"),
                                      sound: sound,
                                      fileName: MusicService.crescentMoon,
                                    ),
                                    const PreviewButton(),
                                    const Leaderboards()
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: const [
                                    StartGameButton(),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    BackToMenuButton()
                                  ],
                                ),
                              ]),
                            ]
                          : [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  StartGameButton(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  BackToMenuButton()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 0),
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
                                  MusicPlayerWidget(
                                    key: const Key("music-widget"),
                                    sound: sound,
                                    fileName: MusicService.crescentMoon,
                                  ),
                                  const PreviewButton(),
                                  const Leaderboards()
                                ],
                              ),
                            ],
                    ],
                  ))),
        ),
        gameStatus == GameStatus.done
            ? const GameCompletionDialog(
                key: Key("game-completion-dialog"),
              )
            : const SizedBox()
      ],
    );
  }
}
