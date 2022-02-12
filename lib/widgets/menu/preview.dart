import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
              tag: "peak",
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                    width: constraints.maxWidth / 2,
                    height: constraints.maxHeight / 2,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.asset(
                      "images/windmill_preview.png",
                      fit: BoxFit.contain,
                    )),
              ))),
    );
  }
}
