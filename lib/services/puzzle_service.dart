import 'dart:math';

import 'package:hackathon_slide_puzzle/interfaces/position.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

typedef Puzzle = List<Tile>;

enum GameStatus { playing, done }

abstract class PuzzleService {
  static Puzzle init({int size = 4}) {
    Puzzle tiles = [];
    int number = 1;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        tiles.add(Tile(
          position: Position(x: j, y: i),
          currentPosition: Position(x: j, y: i),
          number: number,
          isWhitespace: i == size - 1 && j == size - 1,
        ));
        number++;
      }
    }
    return tiles;
  }

  static GameStatus getGameStatus(Puzzle tiles) {
    var i = 0;
    return tiles.every((Tile tile) {
      bool isDone = i == tile.number;
      i++;
      return isDone;
    })
        ? GameStatus.done
        : GameStatus.playing;
  }

  static double calculateTileAbsPosition(
      double measure, int x, int puzzleSize) {
    return (measure / puzzleSize) * x.toDouble();
  }

  static Puzzle sortTiles(Puzzle tiles) {
    return tiles.toList()
      ..sort((Tile tileA, Tile tileB) =>
          tileA.currentPosition.compareTo(tileB.currentPosition));
  }

  static Puzzle onTap(Puzzle tiles, Tile tappedTile) {
    int tappedTileIndex = -1, emptyTileIndex = -1;

    if (tappedTile.isWhitespace) {
      return tiles;
    }

    tappedTileIndex = tiles.indexWhere((tile) =>
        tile.currentPosition.compareTo(tappedTile.currentPosition) == 0);
    emptyTileIndex = tiles.indexWhere((tile) => tile.isWhitespace);

    if (tappedTileIndex == -1 || emptyTileIndex == -1) {
      return tiles;
    }

    final emptyTilePosition = tiles[emptyTileIndex].currentPosition;

    Puzzle changedTiles = List.generate(tiles.length, (index) {
      if (index == emptyTileIndex) {
        return tiles[tappedTileIndex].clone(nextPosition: emptyTilePosition);
      }

      if (index == tappedTileIndex) {
        return tiles[emptyTileIndex]
            .clone(nextPosition: tappedTile.currentPosition);
      }

      return tiles[index];
    });

    return changedTiles;
  }

  // static Puzzle shuffle(Puzzle tiles) {
  //   final numbers = List.generate(tiles.length, (_,index) => index);
  //   return List.generate(numbers.length, (index) {
  //     final randomNumberIndex =
  //     numbers[Random()]
  //   })
  // }
}
