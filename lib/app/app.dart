import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sliding_scene/app/puzzles/windmill.dart';
import 'package:sliding_scene/app/routes/route.dart' as route;
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/services/puzzle_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

import 'package:redux/redux.dart';
import 'package:sliding_scene/utils/responsive_tile_size.dart' as tile_size;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final store = Store<PuzzleState>(puzzleReducer,
      initialState: PuzzleState(
          tiles: puzzleService.init(size: 4),
          correctTiles: [],
          metadata: windmillPuzzle(),
          tileSize: tile_size.large));

  @override
  void initState() {
    precacheImage(Image.asset("images/windmill_preview.png").image, context);
    super.initState();
  }

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
