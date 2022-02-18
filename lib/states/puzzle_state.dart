import 'package:sliding_scene/interfaces/metadata.dart';
import 'package:sliding_scene/services/puzzle_service.dart';

const zeroSecondsDuration = Duration(seconds: 0);

class PuzzleState {
  PuzzleState({
    required this.tiles,
    required this.correctTiles,
    required this.metadata,
    required this.tileSize,
    required this.sound,
    this.size = 4,
    this.gameStatus = GameStatus.notPlaying,
    this.moves = 0,
    this.secondsElpased = Duration.zero,
  });

  Puzzle tiles = [];
  int size;
  GameStatus gameStatus = GameStatus.notPlaying;
  List<int> correctTiles;
  PuzzleMetadata metadata;
  double tileSize;
  int moves;
  Duration secondsElpased;
  bool sound;
}
