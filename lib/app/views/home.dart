import 'package:flutter/material.dart';
import 'package:sliding_scene/app/views/puzzle_view.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/widgets/leaderboards.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  PageRouteBuilder transitionToPuzzle() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 2),
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

  Widget menuButton(String text, void Function() onTap) {
    return Ink(
      width: 100,
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.red, width: 0.5),
          borderRadius: BorderRadius.circular(50),
          color: ThemeColors.yellow),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            center: const Alignment(0, 0),
            stops: const [
              0.30,
              0.70,
            ],
            radius: 2.0,
            colors: [
              ThemeColors.darkBlue,
              ThemeColors.red,
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menuButton(
                "Play",
                () => Navigator.push(context, transitionToPuzzle()),
              ),
              const SizedBox.square(dimension: 500, child: Leaderboards())
            ],
          ),
        ));
  }
}
