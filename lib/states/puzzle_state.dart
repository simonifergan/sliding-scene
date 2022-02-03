import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';

const double tileSize = 180; // Desktop

class PuzzleState {
  PuzzleState({required this.tiles, this.size = 4}) {
    gameStatus = PuzzleService.getGameStatus(tiles);
  }

  Puzzle tiles = [];
  int size;
  GameStatus gameStatus = GameStatus.done;
}
