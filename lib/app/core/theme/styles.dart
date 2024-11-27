import 'package:flutter/material.dart';

class AppStyles {
  // 카드 스타일
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // 버튼 스타일
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[500],
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // 리스트 타일 스타일
  static ListTileThemeData listTileTheme = ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
  );
}
