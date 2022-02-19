import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  late AssetsAudioPlayer _tickSoundAssetPlayer;

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
      playTickSound(store);
      await Future.delayed(const Duration(milliseconds: 950));
    }
    playTickSound(store);

    setState(() {
      _shuffles++;
    });

    _overlayEntry.markNeedsBuild();

    return Future.delayed(
        const Duration(seconds: 1), () => handleShuffling.call(store));
  }

  Future<void> playTickSound(dynamic store) async {
    final sound = store?.state?.sound;
    if (!sound) {
      return;
    }
    await _tickSoundAssetPlayer.stop();
    await _tickSoundAssetPlayer.seek(Duration.zero, force: true);
    unawaited(_tickSoundAssetPlayer.play());
  }

  @override
  void initState() {
    super.initState();
    _tickSoundAssetPlayer = AssetsAudioPlayer.withId("tick-sound");
    _tickSoundAssetPlayer.open(Audio.file("assets/sounds/effects/tick.mp3"),
        autoStart: false);
    _shuffles = 0;
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
                decoration: BoxDecoration(color: ThemeColors.backdrop),
              ),
            ));

    Overlay.of(context)!.insert(_overlayEntry);
  }

  void hideOverlayEntry() {
    _overlayEntry.remove();
  }

  @override
  void dispose() {
    _tickSoundAssetPlayer.dispose();
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
