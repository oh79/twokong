import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF4B89DC);
  static const backgroundColor = Color(0xFFF2F4F6);
  static const surfaceColor = Colors.white;
  static const textColor = Color(0xFF191F28);
  static const secondaryTextColor = Color(0xFF8B95A1);
  static const borderColor = Color(0xFFE5E8EB);

  static final elevation1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final elevation2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static const duration = Duration(milliseconds: 200);
  static const curve = Curves.easeInOut;
  static const animationDuration = Duration(milliseconds: 300);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: primaryColor,
      surface: surfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textColor,
      elevation: 0,
    ),
  );
}
