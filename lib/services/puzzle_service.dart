import 'package:hackathon_slide_puzzle/interfaces/position.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';

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

  bool _isInversion(Tile tileA, Tile tileB) {
    if (!tileB.isWhitespace && tileA.number != tileB.number) {
      if (tileB.number < tileA.number) {
        return tileB.currentPosition.compareTo(tileA.currentPosition) > 0;
      } else {
        return tileA.currentPosition.compareTo(tileB.currentPosition) > 0;
      }
    }
    return false;
  }

  bool isSolvable(Puzzle tiles) {
    int inversions = 0;
    for (var i = 0; i < tiles.length; i++) {
      final tileA = tiles[i];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var j = i + 1; j < tiles.length; j++) {
        final tileB = tiles[j];
        inversions += _isInversion(tileA, tileB) ? 1 : 0;
      }
    }

    return inversions.isEven;
  }

  GameStatus getGameStatus(Puzzle tiles, List<int> correctTiles) {
    return tiles.length - 1 == correctTiles.length
        ? GameStatus.done
        : GameStatus.playing;
  }

  double calculateTileAbsPosition(double measure, int x, int puzzleSize) {
    return (measure / puzzleSize) * x.toDouble();
  }

  Puzzle sortTiles(Puzzle tiles) {
    return tiles.toList()
      ..sort((Tile tileA, Tile tileB) =>
          tileA.currentPosition.compareTo(tileB.currentPosition));
  }

  Tile _getWhitespaceTile(Puzzle tiles) {
    // WHY YOU LOOK AT MY CODE?
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

    final whitespaceTile = _getWhitespaceTile(tiles);

    // Not in row or column
    if (whitespaceTile.currentPosition.x != currentTile.currentPosition.x &&
        whitespaceTile.currentPosition.y != currentTile.currentPosition.y) {
      return tiles;
    }

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
      if (tile.isWhitespace) {
        continue;
      }

      if (tile.currentPosition.compareTo(tile.position) == 0) {
        correctTiles.add(tile.number);
      }
    }

    return correctTiles;
  }

  Puzzle shuffle(Puzzle tiles) {
    final List<Position> availablePosition = [];
    for (var tile in tiles) {
      if (tile.isWhitespace) {
        continue;
      }

      availablePosition.add(tile.position);
    }
    availablePosition.shuffle();
    final shuffledTiles = List.generate(tiles.length, (index) {
      final currentTile = tiles[index];
      if (currentTile.isWhitespace) {
        return currentTile.clone(nextPosition: currentTile.position);
      }

      return currentTile.clone(nextPosition: availablePosition.removeAt(0));
    });

    final shouldReShuffle = !isSolvable(shuffledTiles);

    return shouldReShuffle ? shuffle(shuffledTiles) : shuffledTiles;
  }
}

final puzzleService = PuzzleService();
