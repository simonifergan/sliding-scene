import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';
import 'package:hackathon_slide_puzzle/widgets/rive_animation.dart';

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

    return AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: FractionalOffset(calculateAlignment(tile.currentPosition.x),
            calculateAlignment(tile.currentPosition.y)),
        child: GestureDetector(
            onTap: () {
              print(tile.currentPosition);
              StoreProvider.of<PuzzleState>(context).dispatch(
                  PuzzleAction(type: PuzzleActions.moveTile, payload: tile));
            },
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: tile.position.compareTo(tile.currentPosition) == 0
                          ? Colors.yellow
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(4)),
                width: tileSize,
                height: tileSize,
                child: RiveAnimationWidget(
                  artboard: tile.number.toString(),
                ))));
  }
}
