import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/music_player.dart';

class _ViewModel {
  _ViewModel({
    required this.gameStatus,
    required this.onTapShuffle,
  });

  final GameStatus gameStatus;
  final void Function() onTapShuffle;
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void handleShuffling(dynamic store) async {
    if (shuffles >= 3) {
      setState(() {
        shuffles = 0;
      });
      store.dispatch(PuzzleAction(
          type: PuzzleActions.setGameStatus, payload: GameStatus.playing));
      return;
    }
    if (shuffles == 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      shuffles++;
    });

    store.dispatch(
        PuzzleAction(type: PuzzleActions.shuffleBoard, payload: null));

    Timer(const Duration(seconds: 1), () => handleShuffling(store));
  }

  _ViewModel converter(store) => _ViewModel(
      gameStatus: store.state.gameStatus,
      onTapShuffle: () {
        handleShuffling(store);
      });

  late int shuffles;
  @override
  void initState() {
    shuffles = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
      converter: converter,
      builder: (_context, viewModel) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 200,
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 0.5,
                    spreadRadius: 3)
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF3c4274)),
          child: Column(
            children: [
              Text("${3 - shuffles}"),
              const MusicPlayerWidget(),
              InkWell(
                  onTap: viewModel.onTapShuffle,
                  child: Text(viewModel.gameStatus != GameStatus.playing
                      ? "Start"
                      : "Restart"))
            ],
          ),
        ),
      ),
    );
  }
}
