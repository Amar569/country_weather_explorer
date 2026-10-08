import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const primary = Color(0xFF4F46E5);
  static const secondary = Color(0xFF7C3AED);
  static const background = Color(0xFFF4F6FB);
  static const ink = Color(0xFF1B1B3A);
  static const muted = Color(0xFF6B7280);

  static const headerGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const weatherGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const softShadow = [
    BoxShadow(color: Color(0x143B3B6B), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: primary);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE3E7F2)),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: primary, width: 1.6)),
        errorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.6)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFE3E7F2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}