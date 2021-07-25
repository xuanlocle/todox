import 'package:flutter/material.dart';

class CommonTheme {
  static ThemeData baseTheme = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Colors.blue,
  );

  static ThemeData customBackgroundTheme(color) =>
      baseTheme.copyWith(backgroundColor: color);
}
