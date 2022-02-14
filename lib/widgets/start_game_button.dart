import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';

class _ViewModel {
  _ViewModel({
    required this.gameStatus,
    required this.onTapShuffle,
  });

  final GameStatus gameStatus;
  final void Function() onTapShuffle;
}

class StartGameButton extends StatefulWidget {
  const StartGameButton({Key? key}) : super(key: key);

  @override
  _StartGameButtonState createState() => _StartGameButtonState();
}

class _StartGameButtonState extends State<StartGameButton> {
  late int _shuffles;
  late OverlayEntry _overlayEntry;

  Future<void> handleShuffling(dynamic store) async {
    if (_shuffles >= 3) {
      hideOverlayEntry();
      setState(() {
        _shuffles = 0;
      });

      return;
    }

    store.dispatch(
        PuzzleAction(type: PuzzleActions.shuffleBoard, payload: _shuffles));
    await Future.microtask(() => null);

    if (_shuffles == 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _shuffles++;
    });

    _overlayEntry.markNeedsBuild();

    return Future.delayed(
        const Duration(seconds: 1), () => handleShuffling.call(store));
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
                            fontSize: 100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = ThemeColors.darkBlue),
                      ),
                      Text(
                        3 - _shuffles != 0 ? "${3 - _shuffles}" : "Go!",
                        style: const TextStyle(
                          color: Color(0xFFFAFF73),
                          fontStyle: FontStyle.italic,
                          fontSize: 100,
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
            onTapShuffle: () async {
              await handleShuffling(store);
              store.dispatch(PuzzleAction(
                  type: PuzzleActions.setGameStatus,
                  payload: GameStatus.playing));
            }),
        builder: (_context, viewModel) => Material(
              type: MaterialType.transparency,
              child: Ink(
                width: 100,
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.darkBlue, width: 0.5),
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.red),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      showOverlayEntry();
                      viewModel.onTapShuffle();
                    },
                    child: Text(
                      viewModel.gameStatus != GameStatus.playing
                          ? "Start"
                          : "Restart",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
