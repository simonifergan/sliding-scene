import 'package:hackathon_slide_puzzle/interfaces/position.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';

typedef Puzzle = List<Tile>;

class PuzzleService {
  static Puzzle init() {
    Puzzle tiles = [];
    int number = 0;
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        final posX = i + 1;
        final posY = j + 1;
        tiles.add(Tile(
          position: Position(x: i, y: j),
          currentPosition: Position(x: i, y: j),
          number: number,
          isWhitespace: i == 4 - 1 && j == 4 - 1,
        ));
        number++;
      }
    }
    return tiles;
  }

  static Puzzle onTap(Puzzle tiles, Tile tappedTile) {
    print("TAPPALAB");
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
}
