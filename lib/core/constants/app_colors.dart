import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF12A19A);
  static const Color primaryColor1 = Color(0xFF15C2BA);
  static const Color primaryColor2 = Color(0xFF31C3BC);
  static const Color primaryColor3 = Color(0xFF0B7D77);
  static const Color primaryColor4 = Color(0xFF078C86);
  static const Color secondaryColor = Color(0xFFD17505);
  static const Color lightGrey = Color(0xFFF3F3F3);
  static const Color textSecondaryColor = Color(0xFF332D81);
  static const Color messagingBackground = Color(0xFFDED4C2);
  static const Color onlineIndicatorColor = Color(0xFF60CFC6);
  static const Color blue = Color(0xFF0493BA);
  static const Color welcomeGradient1 = Color(0xFF078C86);
  static const Color welcomeGradient2 = Color(0xFF12A19A);
  static const Color welcomeGradient3 = Color(0xFFFEF38D);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
