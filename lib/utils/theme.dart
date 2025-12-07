// lib/utils/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // --- warna utama (tetap gunakan nilai milikmu) ---
  static const Color primaryTeal = Color.fromARGB(255, 42, 233, 3);
  static const Color linkBlue = Color(0xFF1D4AE8);

  // warna bantu / netral
  static const Color surfaceLight = Color(0xFFF6F7F9);
  static const Color grey100 = Color(0xFFF1F3F5);
  static const Color grey300 = Color(0xFFE0E6EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // ukuran global
  static const double bottomNavHeight = 64.0;
  static const double fabSize = 56.0;
  static const double cornerRadiusSmall = 8.0;
  static const double cornerRadiusMedium = 12.0;
  static const double chipHeight = 44.0;

  // ThemeData dasar (dipakai oleh MaterialApp)
  static final ThemeData themeData = ThemeData(
    useMaterial3: false,
    primaryColor: primaryTeal,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0.5,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      // Mapping dari nama lama:
      // headline6 -> titleLarge
      // subtitle1 -> titleMedium
      // bodyText2 -> bodyMedium
      // button -> labelLarge
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadiusMedium),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: grey100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  // --- Style / dekorasi reusable untuk tasks UI ---

  // Chip style (selected / unselected)
  static BoxDecoration chipSelectedDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? primaryTeal,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration chipUnselectedDecoration() {
    return BoxDecoration(
      color: Colors.tealAccent.withAlpha((0.12 * 255).round()),
      borderRadius: BorderRadius.circular(20),
    );
  }

  // Message bubble decoration (reuse)
  static BoxDecoration messageBubbleDecoration(Color background) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // Small helpers for text styles (bisa dipakai langsung)
  static TextStyle chipTextStyle(bool selected) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: selected ? Colors.white : Colors.black87,
    );
  }

  static TextStyle bottomLabelStyle(bool selected, Color activeColor) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: selected ? activeColor : Colors.grey[600],
    );
  }
}
