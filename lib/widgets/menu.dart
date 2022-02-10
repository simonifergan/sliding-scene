import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _ViewModel {
  _ViewModel({required this.gameStatus, required this.handleShuffle});

  final GameStatus gameStatus;
  final void Function() handleShuffle;
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<PuzzleState, _ViewModel>(
      converter: (store) => _ViewModel(
          gameStatus: store.state.gameStatus,
          handleShuffle: () {
            store.dispatch(
                PuzzleAction(type: PuzzleActions.shuffleBoard, payload: null));
          }),
      builder: (_context, viewModel) => SizedBox(
        width: tileSize * 4,
        child: Card(
            child: Material(
          child: Column(
            children: [
              IconButton(
                  onPressed: viewModel.handleShuffle,
                  icon: const Icon(Icons.replay_rounded)),
            ],
          ),
        )),
      ),
    );
  }
}
