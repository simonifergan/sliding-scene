import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/interfaces/tile.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 1,
                spreadRadius: 2,
                blurStyle: BlurStyle.outer)
          ], borderRadius: BorderRadius.circular(10), color: Colors.white),
          constraints: BoxConstraints(
              maxWidth: state.tileSize * 5, maxHeight: state.tileSize * 5),
          child: Stack(
            fit: StackFit.loose,
            key: const Key("board"),
            clipBehavior: Clip.none,
            children: state.tiles.map(renderTile).toList(),
          )),
    );
  }
}
