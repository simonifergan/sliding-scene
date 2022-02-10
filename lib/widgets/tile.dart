import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/interfaces/tile.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/rive_animation.dart';

class TileWidget extends StatefulWidget {
  const TileWidget({Key? key, required this.tile}) : super(key: key);
  final Tile tile;
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
  double calculateAlignment(int valueOnAxis) {
    final gap = valueOnAxis != 0 ? valueOnAxis / 320 : 0;
    final initialPosition = ((valueOnAxis + 0.5) / 4);
    return initialPosition + gap;
  }

  @override
  Widget build(BuildContext context) {
    final tile = widget.tile;
    final isInPosition = tile.position.compareTo(tile.currentPosition) == 0;

    return AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: FractionalOffset(calculateAlignment(tile.currentPosition.x),
            calculateAlignment(tile.currentPosition.y)),
        child: GestureDetector(
            onTap: () {
              StoreProvider.of<PuzzleState>(context).dispatch(
                  PuzzleAction(type: PuzzleActions.moveTile, payload: tile));
            },
            child: AnimatedContainer(
                key: Key("tile-animated-container-${tile.number}"),
                duration: const Duration(milliseconds: 300),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: isInPosition
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        blurRadius: 1.5,
                        spreadRadius: 0.0,
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                      ),
                    ]),
                width: tileSize,
                height: tileSize,
                child: RiveAnimationWidget(
                  key: Key("rive-animation-tile-${tile.number}"),
                  tile: tile,
                ))));
  }
}
