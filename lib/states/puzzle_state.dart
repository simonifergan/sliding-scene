import 'package:sliding_scene/interfaces/metadata.dart';
import 'package:sliding_scene/services/puzzle_service.dart';

// const double tileSize = 180; // Desktop
// const double tileSize = 60; // mobile

class PuzzleState {
  PuzzleState({
    required this.tiles,
    required this.correctTiles,
    required this.metadata,
    required this.tileSize,
    this.size = 4,
    this.gameStatus = GameStatus.notPlaying,
    this.moves = 0,
    this.startTime,
  });

  Puzzle tiles = [];
  int size;
  GameStatus gameStatus = GameStatus.notPlaying;
  List<int> correctTiles;
  PuzzleMetadata metadata;
  double tileSize;
  int moves;
  DateTime? startTime;
}
