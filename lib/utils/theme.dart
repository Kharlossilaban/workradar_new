import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryTeal = Color.fromARGB(255, 42, 233, 3);
  static const Color linkBlue = Color(0xFF1D4AE8);

  static final ThemeData themeData = ThemeData(
    useMaterial3: false,
    primaryColor: primaryTeal,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: Colors.white,
  );
}
