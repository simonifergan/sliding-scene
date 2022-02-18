import 'package:flutter/material.dart';

class MenuTextStyle extends TextStyle {
  const MenuTextStyle({
    this.bold = true,
    this.size = 24,
  });

  final bool bold;
  final double size;

  @override
  Color? get color => Colors.white;

  @override
  FontStyle? get fontStyle => FontStyle.italic;

  @override
  FontWeight? get fontWeight => bold ? FontWeight.w500 : FontWeight.normal;

  @override
  double? get fontSize => size;
}
