import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/music_player.dart';
import 'package:sliding_scene/widgets/timer.dart';

class _ViewModel {
  _ViewModel(
      {required this.gameStatus,
      required this.onTapShuffle,
      required this.moves,
      required this.tileSize});

  final GameStatus gameStatus;
  final void Function() onTapShuffle;
  final int moves;
  final double tileSize;
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int _shuffles;
  late OverlayEntry _overlayEntry;

  void handleDoneShuffling(dynamic store) {
    store.dispatch(PuzzleAction(
        type: PuzzleActions.setGameStatus, payload: GameStatus.playing));
    setState(() {
      _shuffles = 0;
    });
  }

  void handleShuffling(dynamic store) async {
    if (_shuffles >= 3) {
      hideOverlayEntry();
      handleDoneShuffling(store);
      return;
    }

    if (_shuffles == 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _shuffles++;
    });

    _overlayEntry.markNeedsBuild();

    store.dispatch(
        PuzzleAction(type: PuzzleActions.shuffleBoard, payload: null));

    Timer(const Duration(seconds: 1), () {
      handleShuffling(store);
    });
  }

  @override
  void initState() {
    _shuffles = 0;

    super.initState();
  }

  void showOverlayEntry() {
    _overlayEntry = OverlayEntry(
        builder: (context) => Center(
              child: Container(
                child: Center(
                    child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Text(
                        3 - _shuffles != 0 ? "${3 - _shuffles}" : "Go!",
                        style: TextStyle(
                            fontFamily: "MaShanZheng",
                            fontSize: 58,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black),
                      ),
                      Text(
                        3 - _shuffles != 0 ? "${3 - _shuffles}" : "Go!",
                        style: const TextStyle(
                          color: Color(0xFF2eb398),
                          fontFamily: "MaShanZheng",
                          fontSize: 58,
                        ),
                      ),
                    ],
                  ),
                )),
                decoration: BoxDecoration(
                    color: const Color(0xFF454545).withOpacity(0.2)),
              ),
            ));

    Overlay.of(context)!.insert(_overlayEntry);
  }

  void hideOverlayEntry() {
    _overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
      converter: (store) => _ViewModel(
          gameStatus: store.state.gameStatus,
          moves: store.state.moves,
          tileSize: store.state.tileSize,
          onTapShuffle: () {
            store.dispatch(PuzzleAction(
                type: PuzzleActions.setGameStatus,
                payload: GameStatus.shuffling));
            handleShuffling(store);
          }),
      builder: (_context, viewModel) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: viewModel.tileSize * 5,
          height: 60,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 0.5,
                    spreadRadius: 3)
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF454545)),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(viewModel.moves.toString()),
                        const GameSessionTimer(),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          const MusicPlayerWidget(),
                          InkWell(
                            onTap: () {
                              showOverlayEntry();
                              viewModel.onTapShuffle();
                            },
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xFF2eb398)),
                              child: Center(
                                child: Text(
                                  viewModel.gameStatus != GameStatus.playing
                                      ? "Start"
                                      : "Restart",
                                  style: const TextStyle(
                                      fontFamily: "MaShanZheng", fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
