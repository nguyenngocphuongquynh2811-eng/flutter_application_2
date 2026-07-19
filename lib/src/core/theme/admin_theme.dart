import 'package:flutter/material.dart';

class AdminColors {
  AdminColors._();

  static const sidebar       = Color(0xFF16204A);
  static const sidebarActive = Color(0xFF3D5AFE);
  static const sidebarText   = Color(0xFFC3CAE4);
  static const background    = Color(0xFFF2F4F8);
  static const border        = Color(0xFFE4E7EE);
}

ThemeData buildAdminTheme() {
  final base = ThemeData.light(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AdminColors.background,

    colorScheme: base.colorScheme.copyWith(
      primary: AdminColors.sidebarActive,
      surface: Colors.white,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AdminColors.border),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AdminColors.border),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AdminColors.sidebarActive;
          }
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFE2E6F0);
          }
          return const Color(0xFFEDEFF4);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.pressed)
              ? Colors.white
              : const Color(0xFF3A4256);
        }),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AdminColors.border, space: 1),
  );
}