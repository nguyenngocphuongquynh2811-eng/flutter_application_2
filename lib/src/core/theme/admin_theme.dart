import 'package:flutter/material.dart';

class AdminColors {
  AdminColors._();

  static const background = Color(0xFF000000); // nền trang
  static const surface    = Color(0xFF1C1C1E); // card, thanh dưới
  static const surfaceAlt = Color(0xFF2C2C2E); // ô nhập, viền
  static const accent     = Color(0xFF0A84FF); // xanh dương iOS
  static const border     = Color(0xFF38383A);
  static const textDim    = Color(0xFF8E8E93); // chữ phụ, mục chưa chọn
}

ThemeData buildAdminTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AdminColors.background,

    colorScheme: base.colorScheme.copyWith(
      primary: AdminColors.accent,
      surface: AdminColors.surface,
      onSurface: Colors.white,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        borderSide: const BorderSide(color: AdminColors.accent, width: 1.5),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return AdminColors.accent;
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF3A3A3C);
          }
          return AdminColors.surfaceAlt;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.pressed)
              ? Colors.white
              : const Color(0xFFE5E5EA);
        }),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AdminColors.border, space: 1),
  );
}