import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

class ShuffleButton extends StatefulWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  _ShuffleButtonState createState() => _ShuffleButtonState();
}

class _ViewModel {
  _ViewModel({required this.gameStatus, required this.handleShuffle});

  final GameStatus gameStatus;
  final void Function() handleShuffle;
}

class _ShuffleButtonState extends State<ShuffleButton> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
        converter: (store) => _ViewModel(
            gameStatus: store.state.gameStatus,
            handleShuffle: () {
              store.dispatch(PuzzleAction(
                  type: PuzzleActions.shuffleBoard, payload: null));
            }),
        builder: (_context, viewModel) => Row(children: [
              Text("${viewModel.gameStatus}"),
              IconButton(
                  onPressed: viewModel.handleShuffle,
                  icon: const Icon(Icons.replay_rounded))
            ]));
  }
}
