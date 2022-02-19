import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/reducers/puzzle_reducer.dart';
import 'package:sliding_scene/states/puzzle_state.dart';

class ResponseTileSize {
  static get xsmall => 60.0;
  static get small => 80.0;
  static get medium => 100.0;
  static get large => 120.0;
  static get xlarge => 160.0;
  static get xxlarge => 180.0;
}

double getTileSize(BoxConstraints constraints) {
  double tileSize;

  if (constraints.maxWidth < 410) {
    tileSize = ResponseTileSize.xsmall;
  } else if (constraints.maxWidth < 760) {
    tileSize = ResponseTileSize.small;
  } else if (constraints.maxWidth < 900) {
    tileSize = ResponseTileSize.medium;
  } else if (constraints.maxWidth < 1100) {
    tileSize = ResponseTileSize.large;
  } else if (constraints.maxWidth < 1200) {
    tileSize = ResponseTileSize.xlarge;
  } else {
    tileSize = ResponseTileSize.xxlarge;
  }

  return tileSize;
}

class WithResponsiveLayout extends StatelessWidget {
  const WithResponsiveLayout({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      StoreProvider.of<PuzzleState>(context).dispatch(
          PuzzleAction(type: PuzzleActions.setTileSize, payload: constraints));

      return child;
    });
  }
}
