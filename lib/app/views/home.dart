import 'package:flutter/material.dart';
import 'package:sliding_scene/app/views/puzzle_view.dart';

const size = 500.0;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  PageRouteBuilder transitionToPuzzle() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 3),
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
      color: Colors.grey[200],
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              child: InkWell(
                child: const Text("hi"),
                onTap: () => Navigator.push(context, transitionToPuzzle()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
