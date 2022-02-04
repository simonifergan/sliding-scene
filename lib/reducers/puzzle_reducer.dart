import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

enum PuzzleActions { moveTile, shuffleBoard }

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
            metadata: state.metadata);
      }
    case PuzzleActions.shuffleBoard:
      {
        return PuzzleState(
            size: state.size,
            tiles: puzzleService.shuffle(state.tiles),
            correctTiles: [],
            metadata: state.metadata);
      }
  }

  return state;
}
