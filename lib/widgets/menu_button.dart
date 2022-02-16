import 'package:flutter/material.dart';
import 'package:sliding_scene/styles/colors.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        width: 100,
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
