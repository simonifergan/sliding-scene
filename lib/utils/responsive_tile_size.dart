import 'package:flutter/material.dart';

const small = 60.0;
const medium = 100.0;
const large = 120.0;
const xlarge = 160.0;
const xxlarge = 180.0;

double getTileSize(BoxConstraints constraints) {
  double tileSize;

  if (constraints.maxWidth < 600) {
    tileSize = small;
  } else if (constraints.maxWidth < 825) {
    tileSize = medium;
  } else if (constraints.maxWidth < 1050) {
    tileSize = large;
  } else if (constraints.maxWidth < 1200) {
    tileSize = xlarge;
  } else {
    tileSize = xxlarge;
  }

  return tileSize;
}
