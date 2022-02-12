import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/hero_dialog.dart';
import 'package:sliding_scene/widgets/music_player.dart';
import 'package:sliding_scene/widgets/menu/preview.dart';
import 'package:sliding_scene/widgets/menu/session_timer.dart';

class _ViewModel {
  _ViewModel(
      {required this.gameStatus,
      required this.onTapShuffle,
      required this.moves,
      required this.tileSize,
      required this.startTime});

  final GameStatus gameStatus;
  final void Function() onTapShuffle;
  final int moves;
  final double tileSize;
  DateTime? startTime;
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
    setState(() {
      _shuffles = 0;
    });
  }

  void handleShuffling(dynamic store) async {
    if (_shuffles >= 3) {
      hideOverlayEntry();
      setState(() {
        _shuffles = 0;
      });
      store.dispatch(PuzzleAction(
          type: PuzzleActions.setGameStatus, payload: GameStatus.playing));
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
                            fontStyle: FontStyle.italic,
                            fontSize: 80,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black),
                      ),
                      Text(
                        3 - _shuffles != 0 ? "${3 - _shuffles}" : "Go!",
                        style: const TextStyle(
                          // color: Color(0xFF2eb398),
                          color: Color(0xFFDB6F6B),
                          fontStyle: FontStyle.italic,
                          fontSize: 80,
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
          startTime: store.state.startTime,
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
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: viewModel.tileSize * 5,
          height: 60,
          // clipBehavior: Clip.antiAlias,
          // decoration: BoxDecoration(
          //     boxShadow: [
          //       BoxShadow(
          //           color: Colors.black.withOpacity(0.05),
          //           blurRadius: 0.5,
          //           spreadRadius: 3)
          //     ],
          //     borderRadius: BorderRadius.circular(10),
          //     // color: const Color(0xFF454545)
          //     color: const Color(0xFF7a7a7a)),
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
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    viewModel.gameStatus == GameStatus.playing &&
                            viewModel.startTime != null
                        ? SessionTimer(
                            startTime: viewModel.startTime,
                          )
                        : const SizedBox(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(HeroDialog(
                                builder: (context) => const Center(
                                  child: Preview(
                                    key: Key("rive-fullscreen"),
                                  ),
                                ),
                              ));
                            },
                            child: const Hero(
                                tag: "peak",
                                child: Icon(Icons.photo_library_outlined)),
                          ),
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
                                  border: Border.all(
                                      color: const Color(0xFF0b1b28), width: 1),
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xFFDB6F6B)),
                              child: Center(
                                child: Text(
                                  viewModel.gameStatus != GameStatus.playing
                                      ? "Start"
                                      : "Restart",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
