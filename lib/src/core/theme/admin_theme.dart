import 'package:flutter/material.dart';

class AdminColors {
  AdminColors._();

  // Nền ứng dụng
  static const background = Color(0xFF000000);

  // Card
 static const surface    = Color(0xFF1C1C1E);
static const surfaceAlt = Color(0xFF2C2C2E); // nền thanh nav, giống app khách
static const accent     = Colors.blue;       // app khách dùng Colors.blue
static const textDim    = Colors.white70;    // app khách dùng white70
  // Viền
  static const border = Color(0xFF38383A);

  // Dùng cho Bottom Navigation
  static const iconActive = accent;
  static const iconInactive = Colors.white70;

  // Màu bóng
  static const shadow = Colors.black26;
}

ThemeData buildAdminTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AdminColors.background,

    colorScheme: base.colorScheme.copyWith(
      primary: AdminColors.accent,
      secondary: AdminColors.accent,
      surface: AdminColors.surface,
      onSurface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AdminColors.background,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      color: AdminColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AdminColors.border),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: AdminColors.surfaceAlt,
      hintStyle: const TextStyle(color: AdminColors.textDim),
      labelStyle: const TextStyle(color: AdminColors.textDim),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AdminColors.accent, width: 1.5),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AdminColors.surfaceAlt,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AdminColors.border,
      space: 1,
    ),
  );
}