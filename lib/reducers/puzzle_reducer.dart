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
        Puzzle tiles = PuzzleService.onTap(state.tiles, action.payload);
        return PuzzleState(size: state.size, tiles: tiles);
      }
    case PuzzleActions.shuffleBoard:
      {
        // return PuzzleState(
        //     size: state.size, tiles: PuzzleService.shuffle(tiles));
      }
  }

  return state;
}
