import 'package:flutter/material.dart';

class ResponseTileSize {
  static get xsmall => 60.0;
  static get small => 80.0;
  static get medium => 120.0;
  static get large => 140.0;
  static get xlarge => 160.0;
  static get xxlarge => 180.0;
}

double getTileSize(BoxConstraints constraints) {
  double tileSize;

  if (constraints.maxWidth < 400) {
    tileSize = ResponseTileSize.xsmall;
  } else if (constraints.maxWidth < 600) {
    tileSize = ResponseTileSize.small;
  } else if (constraints.maxWidth < 825) {
    tileSize = ResponseTileSize.medium;
  } else if (constraints.maxWidth < 1050) {
    tileSize = ResponseTileSize.large;
  } else if (constraints.maxWidth < 1200) {
    tileSize = ResponseTileSize.xlarge;
  } else {
    tileSize = ResponseTileSize.xxlarge;
  }

  return tileSize;
}
