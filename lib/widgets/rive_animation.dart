import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimationWidget extends StatefulWidget {
  const RiveAnimationWidget({Key? key, required this.artboard})
      : super(key: key);
  final String artboard;
  @override
  _RiveAnimationWidgetState createState() => _RiveAnimationWidgetState();
}

class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'rive/windmill_animation_scattered.riv',
      artboard: widget.artboard,
      fit: BoxFit.fill,
    );
  }
}
