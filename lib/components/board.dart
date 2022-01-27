import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/components/puzzle_tile.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: 472,
        child: Container(
            color: Colors.grey[100],
            child: BoardGrid(
              key: const Key("board-grid"),
            )));
  }
}

class BoardGrid extends StatelessWidget {
  BoardGrid({Key? key}) : super(key: key);
  final AssetsAudioPlayer soundFxPlayer = AssetsAudioPlayer.withId("fx-player");

  @override
  Widget build(BuildContext context) {
    soundFxPlayer.open(Audio.file("assets/sounds/effects/slide.wav"));
    return StoreConnector<PuzzleState, Puzzle>(
        converter: (store) => store.state.tiles,
        builder: (context, Puzzle tiles) => Stack(
                children: List.generate(tiles.length, (index) {
              final tile = tiles[index];
              return AnimatedPositioned(
                  key: Key(tile.number.toString()),
                  duration: const Duration(milliseconds: 150),
                  left: tile.currentPosition.x * 100,
                  top: tile.currentPosition.y * 100,
                  child: tile.isWhitespace
                      ? const SizedBox(width: 100, height: 100)
                      : GestureDetector(
                          child: PuzzleTile(
                            key: Key("animated-tile-${tile.number}"),
                          ),
                          onTap: () {
                            soundFxPlayer.play();
                            StoreProvider.of<PuzzleState>(context).dispatch(
                                PuzzleAction(
                                    type: PuzzleActions.moveTile,
                                    payload: tile));
                          }));
            })));
  }
}
