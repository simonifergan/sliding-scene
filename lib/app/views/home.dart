import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sliding_scene/app/views/puzzle_view.dart';
import 'package:sliding_scene/services/music_service.dart';
import 'package:sliding_scene/states/puzzle_state.dart';
import 'package:sliding_scene/styles/colors.dart';
import 'package:sliding_scene/styles/responsive_tile_size.dart';
import 'package:sliding_scene/widgets/leaderboards.dart';
import 'package:sliding_scene/widgets/music_player.dart';
import 'package:sliding_scene/widgets/random_sliding_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisible = false;

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

  Widget menuText(text) {
    return Text(
      text,
      style: TextStyle(
        color: ThemeColors.yellow,
        fontWeight: FontWeight.bold,
        fontSize: 25,
        letterSpacing: 1.7,
      ),
    );
  }

  Widget menuButton(String text, void Function()? onTap) {
    return Ink(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.red, width: 0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(onTap: onTap, child: menuText(text)),
    );
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 1, milliseconds: 300), () {
      setState(() {
        isVisible = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sound = StoreProvider.of<PuzzleState>(context).state.sound;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: isVisible ? 1 : 0,
      child: WithResponsiveLayout(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
              center: const Alignment(0, 0),
              stops: const [
                0.20,
                0.80,
              ],
              radius: 2,
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 52,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 3,
                  ),
                ),
                const RandomSlidingTile(),
                menuButton(
                  "Play",
                  () => Navigator.push(context, transitionToPuzzle()),
                ),
                Leaderboards(
                  child: menuText("Leaderboards"),
                ),
                menuButton("Credits", () {}),
                MusicPlayerWidget(
                  fileName: MusicService.cozyFireplace,
                  sound: sound,
                ),
              ]
                  .map((child) => Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: child,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
