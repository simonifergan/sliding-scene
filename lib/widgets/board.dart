import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';
import 'package:hackathon_slide_puzzle/widgets/tile.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  Widget renderTile(Tile tile) {
    return tile.isWhitespace
        ? const SizedBox()
        : TileWidget(
            tile: tile,
            key: Key("tile-my-${tile.number}"),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.pink)),
      width: tileSize * 5,
      height: tileSize * 5,
      child: StoreConnector<PuzzleState, Puzzle>(
          converter: (store) => store.state.tiles,
          builder: (context, Puzzle tiles) => Stack(
                fit: StackFit.loose,
                key: const Key("board"),
                clipBehavior: Clip.none,
                children: tiles.map(renderTile).toList(),
              )),
    );
  }
}
