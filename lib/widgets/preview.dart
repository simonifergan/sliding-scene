import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'package:sliding_scene/widgets/hero_dialog.dart';

class Preview extends StatelessWidget {
  Preview({Key? key, this.animated = true}) : super(key: key);

  final bool animated;
  final windmillController = SimpleAnimation("windmill");
  final windmillIdleController = SimpleAnimation("windmill_idle");
  final bonfireController = SimpleAnimation("bonfire");
  final bonfireIdleController = SimpleAnimation("bonfire_idle");

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'rive/windmill.riv',
      artboard: "windmill",
      fit: BoxFit.contain,
      controllers: [windmillIdleController, bonfireIdleController],
      onInit: (artboard) async {
        if (!animated) {
          return;
        }

        await Future.delayed(const Duration(milliseconds: 300));

        artboard.removeController(windmillIdleController);
        artboard.removeController(bonfireIdleController);
        artboard.addController(windmillController);
        artboard.addController(bonfireController);
      },
      placeHolder: Image.asset(
        "images/windmill.png",
        fit: BoxFit.contain,
      ),
    );
  }
}

class PreviewHero extends StatelessWidget {
  const PreviewHero({Key? key}) : super(key: key);

  static String get tag => "preview";

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: PreviewHero.tag,
      child: LayoutBuilder(
          builder: (context, constraints) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: constraints.maxHeight,
                      height: constraints.maxHeight,
                      child: Container(
                          width: constraints.maxWidth / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Preview(
                              key: const Key("rive-preview-fullscreen"))),
                    ),
                  )))),
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
              child: PreviewHero(
                key: Key("preview-hero"),
              ),
            ),
          ));
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Hero(
                tag: PreviewHero.tag,
                child: Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: const EdgeInsets.only(right: 2),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.white,
                    )))));
  }
}
