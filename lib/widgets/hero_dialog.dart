import 'package:flutter/material.dart';

class HeroDialog<T> extends PageRoute<T> {
  HeroDialog({
    required this.builder,
  }) : super();

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => const Color(0xFF454545).withOpacity(0.2);

  @override
  String? get barrierLabel => "Backdrop";

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(
      context,
    );
  }

  @override
  bool get maintainState => false;
}
