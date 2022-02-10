import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/widgets/music_player.dart';

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
        width: 200,
        height: 200,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 0.5,
                    spreadRadius: 3)
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF3c4274)),
          child: Card(
              child: Material(
            child: Column(
              children: [
                const Text("Hi", style: TextStyle(fontFamily: "MaShanZheng")),
                const MusicPlayerWidget(),
                IconButton(
                    onPressed: viewModel.handleShuffle,
                    icon: const Icon(Icons.replay_rounded)),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
