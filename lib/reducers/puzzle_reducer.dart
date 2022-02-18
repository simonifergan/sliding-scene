import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';

enum PuzzleActions {
  moveTile,
  shuffleBoard,
  setGameStatus,
  setTileSize,
  setSecondsElpased,
  setSound
}

class PuzzleAction {
  PuzzleAction({required this.type, required this.payload});

  final PuzzleActions type;
  final dynamic payload;
}

PuzzleState puzzleReducer(PuzzleState state, dynamic action) {
  switch (action.type) {
    case PuzzleActions.moveTile:
      {
        if (puzzleService.isTileBlocked(state.tiles, action.payload)) {
          return state;
        }

        Puzzle tiles = puzzleService.moveTile(state.tiles, action.payload);
        return PuzzleState(
            size: state.size,
            tiles: tiles,
            correctTiles: puzzleService.getCorrectTiles(tiles),
            secondsElpased: state.secondsElpased,
            metadata: state.metadata,
            sound: state.sound,
            tileSize: state.tileSize,
            gameStatus: puzzleService.isComplete(tiles)
                ? GameStatus.done
                : state.gameStatus,
            moves: state.moves + 1);
      }

    case PuzzleActions.shuffleBoard:
      {
        final shuffledTiles = action.payload == 0
            ? puzzleService.sort(state.tiles)
            : puzzleService.shuffle(state.tiles);

        return PuzzleState(
            size: state.size,
            tiles: shuffledTiles,
            correctTiles: puzzleService.getCorrectTiles(shuffledTiles),
            metadata: state.metadata,
            sound: state.sound,
            tileSize: state.tileSize,
            gameStatus: GameStatus.shuffling,
            secondsElpased: Duration.zero);
      }

    case PuzzleActions.setGameStatus:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: [],
          metadata: state.metadata,
          sound: state.sound,
          gameStatus: action.payload,
          tileSize: state.tileSize,
          secondsElpased: action.payload == GameStatus.playing ||
                  action.payload == GameStatus.notPlaying
              ? Duration.zero
              : state.secondsElpased,
          moves: action.payload == GameStatus.notPlaying ? 0 : state.moves);

    case PuzzleActions.setSecondsElpased:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: state.correctTiles,
          metadata: state.metadata,
          sound: state.sound,
          gameStatus: state.gameStatus,
          tileSize: state.tileSize,
          secondsElpased: action.payload,
          moves: state.moves);

    case PuzzleActions.setTileSize:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: state.correctTiles,
          metadata: state.metadata,
          sound: state.sound,
          gameStatus: state.gameStatus,
          tileSize: getTileSize(action.payload),
          moves: state.moves,
          secondsElpased: state.secondsElpased);

    case PuzzleActions.setSound:
      return PuzzleState(
          size: state.size,
          tiles: state.tiles,
          correctTiles: state.correctTiles,
          metadata: state.metadata,
          sound: action.payload,
          gameStatus: state.gameStatus,
          tileSize: state.tileSize,
          moves: state.moves,
          secondsElpased: state.secondsElpased);

    default:
      return state;
  }
}
