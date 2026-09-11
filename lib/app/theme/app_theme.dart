import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';

/// Stravo Pro - Master ThemeData
/// Desain oleh: Ray (Lead UI/UX)
class StravoAppTheme {
  StravoAppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: StravoColors.background,
      colorScheme: const ColorScheme.dark(
        primary: StravoColors.orangePrimary,
        secondary: StravoColors.cyberGreen,
        tertiary: StravoColors.electricCyan,
        surface: StravoColors.surface,
        onPrimary: Colors.white,
        onSurface: StravoColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: StravoColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: StravoTypography.h2,
        iconTheme: IconThemeData(color: StravoColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: StravoColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: StravoColors.glassBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: StravoColors.glassBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
