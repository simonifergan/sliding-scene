import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/app/puzzles/windmill.dart';
import 'package:sliding_scene/app/views/puzzle_view.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

import 'package:redux/redux.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final store = Store<PuzzleState>(puzzleReducer,
      initialState: PuzzleState(
          tiles: puzzleService.init(size: 4),
          correctTiles: [],
          metadata: windmillPuzzle()));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<PuzzleState>(
        store: store,
        child: MaterialApp(
          title: 'Sliding Scene',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              backgroundColor: const Color(0xFF2b3058)),
          home:
              const PuzzleView(key: Key("puzzle-view"), title: 'Sliding Scene'),
        ));
  }
}
