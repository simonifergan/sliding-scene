import 'package:flutter/material.dart';
import 'package:hackathon_slide_puzzle/app/puzzles/windmill.dart';
import 'package:hackathon_slide_puzzle/interfaces/tile.dart';
import 'package:rive/rive.dart';

class RiveAnimationWidget extends StatefulWidget {
  const RiveAnimationWidget(
      {Key? key, required this.tile, required this.correctTiles})
      : super(key: key);
  final Tile tile;
  final List<int> correctTiles;

  @override
  _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  late Artboard selectedArtboard;

  final SimpleAnimation idleController = SimpleAnimation("idle");
  final SimpleAnimation playController = SimpleAnimation("play");
  final WindmillPuzzle windmillPuzzle = WindmillPuzzle();

  @override
  void initState() {
    super.initState();
  }

  void initArtboard(Artboard artboard) {
    setState(() {
      selectedArtboard = artboard;
    });
  }

  bool shouldPlayAnimaion(Tile tile, List<int> correctTiles) {
    return windmillPuzzle.groups
        .any((group) => group.every((index) => correctTiles.contains(index)));
  }

  void checkPosition() {
    final tile = widget.tile;

    if (tile.currentPosition.compareTo(tile.position) == 0 &&
        shouldPlayAnimaion(tile, widget.correctTiles)) {
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
    checkPosition();
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
