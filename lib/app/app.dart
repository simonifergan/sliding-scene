import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/app/puzzles/windmill.dart';
import 'package:sliding_scene/app/routes/route.dart' as route;
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

import 'package:redux/redux.dart';
import 'package:sliding_scene/utils/responsive_tile_size.dart' as tile_size;

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final store = Store<PuzzleState>(puzzleReducer,
      initialState: PuzzleState(
          tiles: puzzleService.init(size: 4),
          correctTiles: [],
          metadata: windmillPuzzle(),
          tileSize: tile_size.large));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<PuzzleState>(
        store: store,
        child: MaterialApp(
          title: 'Sliding Scene',
          theme: ThemeData(),
          onGenerateRoute: route.controller,
          initialRoute: route.puzzleRoute,
        ));
  }
}
