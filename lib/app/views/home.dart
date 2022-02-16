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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.red, width: 0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: ThemeColors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 2,
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
              Text(
                "Sliding Scene",
                style: TextStyle(
                    fontFamily: "MaShanZheng",
                    letterSpacing: 18,
                    color: ThemeColors.yellow,
                    fontSize: 100),
              ),
              const SizedBox(
                height: 200,
              ),
              menuButton(
                "Play",
                () => Navigator.push(context, transitionToPuzzle()),
              ),
              menuButton("Leaderboards", () {}),
              menuButton("Credits", () {}),
              const SizedBox.square(dimension: 500, child: Leaderboards())
            ],
          ),
        ));
  }
}
