import 'dart:math';

import 'package:sliding_scene/interfaces/position.dart';
import 'package:sliding_scene/interfaces/tile.dart';

typedef Puzzle = List<Tile>;

enum GameStatus { playing, done, notPlaying, shuffling }

class PuzzleService {
  Puzzle init({int size = 4}) {
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

  int countInversions(tiles) {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.number != b.number) {
      if (b.number < a.number) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  bool isSolvable(Puzzle tiles) {
    final size = sqrt(tiles.length).toInt();
    final height = tiles.length ~/ size;

    final inversions = countInversions(tiles);

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespaceRow =
        tiles.singleWhere((tile) => tile.isWhitespace).currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    }
    return inversions.isOdd;
  }

  GameStatus getGameStatus(Puzzle tiles, List<int> correctTiles) {
    return tiles.length - 1 == correctTiles.length
        ? GameStatus.done
        : GameStatus.playing;
  }

  double calculateTileAbsPosition(double measure, int x, int puzzleSize) {
    return (measure / puzzleSize) * x.toDouble();
  }

  bool isTileBlocked(Puzzle tiles, Tile currentTile) {
    final whitespaceTile = _getWhitespaceTile(tiles);
    return (whitespaceTile.currentPosition.x != currentTile.currentPosition.x &&
        whitespaceTile.currentPosition.y != currentTile.currentPosition.y);
  }

  Puzzle sortTiles(Puzzle tiles) {
    return tiles.toList()
      ..sort((Tile tileA, Tile tileB) =>
          tileA.currentPosition.compareTo(tileB.currentPosition));
  }

  Tile _getWhitespaceTile(Puzzle tiles) {
    return tiles.singleWhere((tile) => tile.isWhitespace);
  }

  Puzzle _swapTiles(Puzzle tiles, Tile tileToSwap) {
    final whitespaceTile = _getWhitespaceTile(tiles);

    final tileIndex = tiles.indexOf(tileToSwap);
    final whitespaceIndex = tiles.indexOf(whitespaceTile);

    return List.generate(tiles.length, (index) {
      if (index == whitespaceIndex) {
        return tiles[tileIndex]
            .clone(nextPosition: whitespaceTile.currentPosition);
      }

      if (index == tileIndex) {
        return tiles[whitespaceIndex]
            .clone(nextPosition: tileToSwap.currentPosition);
      }

      return tiles[index];
    });
  }

  Puzzle moveTile(Puzzle tiles, Tile currentTile) {
    if (currentTile.isWhitespace) {
      return tiles;
    }

    if (isTileBlocked(tiles, currentTile)) {
      return tiles;
    }

    final whitespaceTile = _getWhitespaceTile(tiles);

    final deltaX =
        whitespaceTile.currentPosition.x - currentTile.currentPosition.x;
    final deltaY =
        whitespaceTile.currentPosition.y - currentTile.currentPosition.y;

    if (deltaX.abs() + deltaY.abs() > 1) {
      final nextX = currentTile.currentPosition.x + deltaX.sign;
      final nextY = currentTile.currentPosition.y + deltaY.sign;

      final blockingTile = tiles.singleWhere((nextTile) =>
          nextTile.currentPosition.x == nextX &&
          nextTile.currentPosition.y == nextY);

      return _swapTiles(moveTile([...tiles], blockingTile), currentTile);
    }
    return _swapTiles(tiles, currentTile);
  }

  List<int> getCorrectTiles(Puzzle tiles) {
    final List<int> correctTiles = [];
    for (var tile in tiles) {
      if (tile.currentPosition.compareTo(tile.position) == 0) {
        correctTiles.add(tile.number);
      }
    }

    return correctTiles;
  }

  Puzzle shuffle(Puzzle tiles) {
    Puzzle shuffledTiles = [];
    do {
      final List<Position> availablePosition =
          List.generate(tiles.length, (index) => tiles[index].position);
      availablePosition.shuffle();
      shuffledTiles = List.generate(tiles.length, (index) {
        final currentTile = tiles[index];

        return currentTile.clone(nextPosition: availablePosition.removeAt(0));
      });
    } while (
        !isSolvable(shuffledTiles) && getCorrectTiles(shuffledTiles).isEmpty);

    return shuffledTiles;
  }
}

final puzzleService = PuzzleService();
