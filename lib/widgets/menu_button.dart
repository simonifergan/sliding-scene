import 'package:flutter/material.dart';
import 'package:sliding_scene/styles/colors.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
  }) : super(key: key);

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
            color: ThemeColors.red),
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Menu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
