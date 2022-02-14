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
    for (var i = 0; i < tiles.length; i++) {
      final tileA = tiles[i];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var j = i + 1; j < tiles.length; j++) {
        final tileB = tiles[j];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (b.isWhitespace) {
      return false;
    }

    if (a.number != b.number) {
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

    if (((height - whitespaceRow)).isOdd) {
      return inversions.isEven;
    }

    return inversions.isOdd;
  }

  bool isComplete(Puzzle tiles) {
    return tiles
        .every((tile) => tile.currentPosition.compareTo(tile.position) == 0);
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
    if (currentTile.isWhitespace || isTileBlocked(tiles, currentTile)) {
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
    final whitespaceTile = _getWhitespaceTile(tiles);
    for (var tile in tiles) {
      if (tile == whitespaceTile) {
        continue;
      }

      if (tile.currentPosition.compareTo(tile.position) == 0) {
        correctTiles.add(tile.number);
      }
    }

    return correctTiles;
  }

  Puzzle _generateShuffledPuzzle(
      List<Position> availablePositions, Puzzle tiles) {
    availablePositions.shuffle();

    return List.generate(availablePositions.length,
        (index) => tiles[index].clone(nextPosition: availablePositions[index]));
  }

  Puzzle shuffle(Puzzle tiles) {
    final List<Position> availablePositions =
        List.generate(tiles.length, (index) => tiles[index].position);

    late Puzzle shuffledTiles;

    shuffledTiles = _generateShuffledPuzzle(availablePositions, tiles);

    while (!isSolvable(shuffledTiles) ||
        getCorrectTiles(shuffledTiles).isNotEmpty) {
      shuffledTiles = _generateShuffledPuzzle(availablePositions, tiles);
    }

    return shuffledTiles;
  }

  Puzzle sort(Puzzle tiles) {
    final clonedTiles = List.generate(tiles.length,
        (index) => tiles[index].clone(nextPosition: tiles[index].position));

    return clonedTiles;
  }
}

final puzzleService = PuzzleService();
