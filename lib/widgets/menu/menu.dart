import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';
import 'package:sliding_scene/widgets/menu/moves.dart';
import 'package:sliding_scene/widgets/music_player.dart';
import 'package:sliding_scene/widgets/preview.dart';
import 'package:sliding_scene/widgets/menu/session_timer.dart';

class _ViewModel {
  _ViewModel(
      {required this.gameStatus,
      required this.moves,
      required this.tileSize,
      required this.secondsElpased});

  final GameStatus gameStatus;

  final int moves;
  final double tileSize;
  Duration? secondsElpased;
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
      converter: (store) => _ViewModel(
        gameStatus: store.state.gameStatus,
        moves: store.state.moves,
        tileSize: store.state.tileSize,
        secondsElpased: store.state.secondsElpased,
      ),
      builder: (_context, viewModel) => Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: BoxConstraints(maxWidth: viewModel.tileSize * 5),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Moves(moves: viewModel.moves),
                        SessionTimer(
                          gameStatus: viewModel.gameStatus,
                          secondsElpased: viewModel.secondsElpased!,
                        )
                      ]),
                  ...viewModel.tileSize < ResponseTileSize.medium
                      ? [
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                PreviewButton(),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                    child: MusicPlayerWidget()),
                              ])
                        ]
                      : []
                ],
              ),
            ),
          )),
    );
  }
}
