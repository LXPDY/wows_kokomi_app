import 'package:flutter/material.dart';

class FontSize {
  static double of(BuildContext context, double fraction) {
    final screenSize = ScreenSize.of(context);
    return screenSize.width * fraction;
  }
}
class ScreenSize {
  final double width;
  final double height;

  ScreenSize._(this.width, this.height);

  static ScreenSize of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenSize._(size.width, size.height);
  }
}