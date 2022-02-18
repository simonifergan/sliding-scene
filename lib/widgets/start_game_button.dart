import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/widgets/menu_button.dart';

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
  late AudioPlayer _tickSoundPlayer;

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
    if (_shuffles == 0) {
      await playTickSound();

      await Future.delayed(const Duration(seconds: 1));
    }

    await playTickSound();

    setState(() {
      _shuffles++;
    });

    _overlayEntry.markNeedsBuild();

    return Future.delayed(
        const Duration(seconds: 1), () => handleShuffling.call(store));
  }

  Future<void> playTickSound() async {
    await _tickSoundPlayer.stop();
    await _tickSoundPlayer.seek(null);
    unawaited(_tickSoundPlayer.play());
  }

  @override
  void initState() {
    super.initState();
    _shuffles = 0;
    _tickSoundPlayer = AudioPlayer();
    _tickSoundPlayer.setAsset(
      "sounds/effects/tick.mp3",
    );
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
  void dispose() {
    _tickSoundPlayer.dispose();
    super.dispose();
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
        builder: (_context, viewModel) => MenuButton(
              text: viewModel.gameStatus == GameStatus.shuffling
                  ? "Ready?"
                  : viewModel.gameStatus != GameStatus.playing
                      ? "Start"
                      : "Restart",
              onTap: () {
                showOverlayEntry();
                viewModel.onTapShuffle();
              },
            ));
  }
}
