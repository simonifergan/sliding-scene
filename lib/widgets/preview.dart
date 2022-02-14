import 'package:flutter/material.dart';
import 'package:sliding_scene/widgets/hero_dialog.dart';

class Preview extends StatelessWidget {
  const Preview({Key? key}) : super(key: key);

  static String get tag => "preview";

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Hero(
              tag: Preview.tag,
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                    width: constraints.maxWidth / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black)),
                    child: Image.asset(
                      "images/windmill_preview.png",
                      fit: BoxFit.fitWidth,
                    )),
              ))),
    );
  }
}

class PreviewButton extends StatelessWidget {
  const PreviewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialog(
            builder: (context) => const Center(
              child: Preview(
                key: Key("rive-fullscreen"),
              ),
            ),
          ));
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Hero(
              tag: Preview.tag,
              child: Container(
                margin: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                ),
              )),
        ));
  }
}
