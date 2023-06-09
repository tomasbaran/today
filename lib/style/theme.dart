import 'package:flutter/material.dart';
import 'package:today/style/style_constants.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: Colors.red,
    highlightColor: kThemeColor9,
    scaffoldBackgroundColor: kBackgroundColor,
    colorScheme: const ColorScheme.light(
      primary: kBackgroundColor,
      secondary: kHighlightColor,
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.white),
    ),
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.black,
  );
}
