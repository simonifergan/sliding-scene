import 'package:flutter/material.dart';
import 'package:sliding_scene/styles/colors.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.text,
    required this.onTap,
    this.width = 100,
    Key? key,
  }) : super(key: key);

  final String text;
  final Function onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        width: width,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.darkBlue, width: 0.5),
            borderRadius: BorderRadius.circular(50),
            color: ThemeColors.yellow),
        child: Center(
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Text(
              text,
              style: TextStyle(
                color: ThemeColors.darkBlue,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
