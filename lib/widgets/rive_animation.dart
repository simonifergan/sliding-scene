import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:hackathon_slide_puzzle/states/puzzle_state.dart';
import 'package:rive/rive.dart';

class RiveAnimationWidget extends StatefulWidget {
  const RiveAnimationWidget({Key? key, required this.tile}) : super(key: key);
  final Tile tile;

  @override
  _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  late Artboard selectedArtboard;

  final SimpleAnimation idleController = SimpleAnimation("idle");
  final SimpleAnimation playController = SimpleAnimation("play");

  @override
  void initState() {
    super.initState();
  }

  void initArtboard(Artboard artboard) {
    setState(() {
      selectedArtboard = artboard;
    });
  }

  bool shouldPlayAnimaion(Tile tile) {
    final state = (StoreProvider.of<PuzzleState>(context).state);
    final correctTiles = state.correctTiles;
    final metadata = state.metadata;

    final isInPosition = tile.currentPosition.compareTo(tile.position) == 0;
    final isGroupAligned = metadata.animationGroups
        .any((group) => group.every((index) => correctTiles.contains(index)));

    return isInPosition && isGroupAligned;
  }

  void handleWidgetUpdate() {
    final tile = widget.tile;

    if (shouldPlayAnimaion(tile)) {
      selectedArtboard.removeController(idleController);
      selectedArtboard.addController(playController);
      return;
    }

    playController.reset();
    selectedArtboard.removeController(playController);
    selectedArtboard.addController(idleController);
  }

  @override
  void didUpdateWidget(covariant RiveAnimationWidget oldWidget) {
    handleWidgetUpdate();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'rive/windmill_2.riv',
      artboard: widget.tile.number.toString(),
      fit: BoxFit.fill,
      onInit: initArtboard,
    );
  }
}
