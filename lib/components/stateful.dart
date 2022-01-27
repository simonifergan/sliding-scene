import 'package:flutter/material.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';

class StateFul extends StatefulWidget {
  const StateFul(Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateFulState();
  }
}

class StateFulState extends State<StateFul> {
  late bool selected;
  late Puzzle tiles;

  @override
  void initState() {
    tiles = PuzzleService.init();
    selected = false;
    super.initState();
  }

  void tap(Tile tile) {
    final newTiles = PuzzleService.onTap(tiles, tile);
    print("I TAP ${tile.number}");
    setState(() {
      tiles = newTiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("TILES ${tiles.length}");
    return Container(
        height: 472,
        child: Stack(
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
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                    ),
                    onTap: () {
                      tap(tile);
                    },
                  ),
          );
        })));
  }
}
