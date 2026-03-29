import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Colors.orangeAccent;
  static const Color gradientTop = Color(0xFFFFE082);
  static const Color gradientBottom = Color(0xFFFFB74D);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      );
}
