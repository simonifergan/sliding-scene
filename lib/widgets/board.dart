import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/interfaces/tile.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/tile.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  Widget renderTile(Tile tile) {
    return tile.isWhitespace
        ? const SizedBox()
        : TileWidget(
            tile: tile,
            key: Key("tile-rendered-${tile.number}"),
          );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, PuzzleState>(
      converter: (store) => store.state,
      builder: (context, PuzzleState state) => Container(
          constraints: BoxConstraints(
              maxWidth: state.tileSize * 5, maxHeight: state.tileSize * 5),
          child: Stack(
            fit: StackFit.loose,
            key: const Key("stack-tiles"),
            clipBehavior: Clip.none,
            children: state.tiles.map(renderTile).toList(),
          )),
    );
  }
}
