import 'package:flutter/material.dart';
import 'package:sliding_scene/app/views/puzzle_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  PageRouteBuilder transitionToPuzzle() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 5),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) =>
          const PuzzleView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: RadialGradient(
        center: Alignment(0, 0),
        stops: [
          0.30,
          0.70,
        ],
        radius: 2.0,
        colors: [
          Color(0xFF0b1b28),
          Color(0xFFd86f6b),
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              child: const Text("hi"),
              onTap: () => Navigator.push(context, transitionToPuzzle()),
            ),
          )
        ],
      ),
    );
  }
}
