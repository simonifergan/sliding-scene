import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/interfaces/metadata.dart';

import 'package:sliding_scene/interfaces/tile.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:rive/rive.dart';

class RiveAnimationWidget extends StatefulWidget {
  const RiveAnimationWidget({Key? key, required this.tile}) : super(key: key);
  final Tile tile;

  @override
  _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  Artboard? selectedArtboard;

  final SimpleAnimation idleController = SimpleAnimation("idle");
  final SimpleAnimation playController = SimpleAnimation("play");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    selectedArtboard?.remove();
    super.dispose();
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
    final animationGroups = metadata.animationGroups;
    final AnimationGroups tileAnimationGroups = [];

    final isInPosition = tile.currentPosition.compareTo(tile.position) == 0;
    for (var i = 0; i < animationGroups.length; i++) {
      if (animationGroups[i].contains(tile.number)) {
        tileAnimationGroups.add(animationGroups[i]);
      }
    }

    final isGroupAligned = tileAnimationGroups
        .any((group) => group.every((index) => correctTiles.contains(index)));

    return isInPosition && isGroupAligned;
  }

  void handleWidgetUpdate() {
    if (selectedArtboard == null) {
      return;
    }
    final tile = widget.tile;

    if (shouldPlayAnimaion(tile)) {
      selectedArtboard?.removeController(idleController);
      selectedArtboard?.addController(playController);
      return;
    }

    idleController.reset();
    playController.reset();
    selectedArtboard?.removeController(playController);
    selectedArtboard?.addController(idleController);
  }

  @override
  void didUpdateWidget(covariant RiveAnimationWidget oldWidget) {
    handleWidgetUpdate();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'rive/windmill.riv',
      artboard: widget.tile.number.toString(),
      fit: BoxFit.fill,
      onInit: initArtboard,
    );
  }
}
