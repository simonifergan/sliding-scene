import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';

const double tileSize = 180; // Desktop

class PuzzleState {
  PuzzleState({
    required this.tiles,
    required this.correctTiles,
    this.size = 4,
  }) {
    gameStatus = puzzleService.getGameStatus(tiles);
  }

  Puzzle tiles = [];
  int size;
  GameStatus gameStatus = GameStatus.done;
  List<int> correctTiles;
}
