import 'package:flutter/material.dart';

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PuzzleTileState();
  }
}

class PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _scale = Tween<double>(begin: 1, end: 0.94).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: 100,
      width: 100,
      color: Colors.green,
    );
    return MouseRegion(
        onEnter: (event) => _controller.forward(),
        onExit: (event) => _controller.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: child,
        ));
  }
}
