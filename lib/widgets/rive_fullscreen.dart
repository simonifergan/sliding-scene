import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveFullscreen extends StatelessWidget {
  const RiveFullscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RiveAnimation.file(
      "rive/windmill.riv",
      fit: BoxFit.cover,
    );
  }
}
