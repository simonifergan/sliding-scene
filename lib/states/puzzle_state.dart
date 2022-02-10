import 'package:hackathon_slide_puzzle/interfaces/metadata.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';

const double tileSize = 180; // Desktop
// const double tileSize = 80; // mobile

class PuzzleState {
  PuzzleState({
    required this.tiles,
    required this.correctTiles,
    required this.metadata,
    this.size = 4,
    this.gameStatus = GameStatus.notPlaying,
  });

  Puzzle tiles = [];
  int size;
  GameStatus gameStatus = GameStatus.notPlaying;
  List<int> correctTiles;
  PuzzleMetadata metadata;
}
