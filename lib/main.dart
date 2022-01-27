import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hackathon_slide_puzzle/components/animation.dart';
import 'package:hackathon_slide_puzzle/components/board.dart';
import 'package:hackathon_slide_puzzle/components/music_player.dart';
import 'package:hackathon_slide_puzzle/reducers/puzzle_reducer.dart';
import 'package:hackathon_slide_puzzle/services/puzzle_service.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';

import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final store = Store<PuzzleState>(puzzleReducer,
      initialState: PuzzleState(tiles: PuzzleService.init()));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<PuzzleState>(
        store: store,
        child: MaterialApp(
          title: 'Sliding Seasons',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Sliding Seasons'),
        ));

    // return MaterialApp(
    //   title: 'Sliding Seasons',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const MyHomePage(title: 'Sliding Seasons'),
    // );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Row(children: [
          Row(children: const [
            Board(),
          ]),
          const SizedBox(child: PlayPauseAnimation(), width: 800, height: 600),
          // const MusicPlayer(
          //   key: Key("music-player-widget"),
          // )
          // const AudioWidget()
        ]));
  }
}
