import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/utils/responsive_tile_size.dart';

enum PuzzleActions { moveTile, shuffleBoard, setGameStatus, setTileSize }

class PuzzleAction {
  PuzzleAction({required this.type, required this.payload});

  final PuzzleActions type;
  final dynamic payload;
}

PuzzleState puzzleReducer(PuzzleState state, dynamic action) {
  switch (action.type) {
    case PuzzleActions.moveTile:
      {
        Puzzle tiles = puzzleService.moveTile(state.tiles, action.payload);
        return PuzzleState(
            size: state.size,
            tiles: tiles,
            correctTiles: puzzleService.getCorrectTiles(tiles),
            metadata: state.metadata,
            tileSize: state.tileSize,
            gameStatus: state.gameStatus);
      }
    case PuzzleActions.shuffleBoard:
      return PuzzleState(
          size: state.size,
          tiles: puzzleService.shuffle(state.tiles),
          correctTiles: [],
          metadata: state.metadata,
          tileSize: state.tileSize,
          gameStatus: state.gameStatus);

    case PuzzleActions.setGameStatus:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: [],
          metadata: state.metadata,
          gameStatus: action.payload,
          tileSize: state.tileSize);

    case PuzzleActions.setTileSize:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: state.correctTiles,
          metadata: state.metadata,
          gameStatus: state.gameStatus,
          tileSize: getTileSize(action.payload));
  }

  return state;
}
