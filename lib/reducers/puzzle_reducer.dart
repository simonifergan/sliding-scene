import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

enum PuzzleActions { moveTile }

class PuzzleAction {
  PuzzleAction({required this.type, required this.payload});

  final PuzzleActions type;
  final dynamic payload;
}

PuzzleState puzzleReducer(PuzzleState state, dynamic action) {
  if (action.type == PuzzleActions.moveTile) {
    print("I MOVED");
    return PuzzleState(tiles: PuzzleService.onTap(state.tiles, action.payload));
  }

  return state;
}
