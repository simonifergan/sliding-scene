import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/components/puzzle_tile.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    required key,
    required this.size,
    required this.index,
  }) : super(key: key);

  final int index;
  final int size;

  @override
  Widget build(BuildContext context) {
    const banana = FractionalOffset((0 - 1) / (100 - 1), (0 - 1) / (100 - 1));
    print("$banana");
    return StoreConnector<PuzzleState, Tile>(
        converter: (store) => store.state.tiles[index],
        builder: (context, Tile tile) => tile.isWhitespace
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  StoreProvider.of<PuzzleState>(context).dispatch(PuzzleAction(
                      type: PuzzleActions.moveTile, payload: tile));
                  // GetIt.instance<PuzzleModel>().onTap(tile);
                },
                child: AnimatedAlign(
                    alignment: FractionalOffset(
                        (tile.currentPosition.x - 1) / (size - 1),
                        (tile.currentPosition.y - 1) / (size - 1)),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: PuzzleTile(
                      key: Key("animated-tile-${tile.number}"),
                    )),
              ));
  }
}
