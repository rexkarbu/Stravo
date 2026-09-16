import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';

/// Stravo Pro - Athletic Typography
/// Desain oleh: Ray (Lead UI/UX)
/// Menggunakan tabular figures (fontFeatures) untuk metrik agar angka tidak bergeser horizontal saat berubah cepat.
class StravoTypography {
  StravoTypography._();

  // Font features untuk angka telemetri yang stabil
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: StravoColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: StravoColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: StravoColors.textPrimary,
  );

  // Large Telemetry Display (Speedometer besar di layar tracking)
  static const TextStyle speedLarge = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    color: StravoColors.textPrimary,
    fontFeatures: tabularFigures,
    height: 1.0,
  );

  static const TextStyle metricValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: StravoColors.textPrimary,
    fontFeatures: tabularFigures,
  );

  static const TextStyle metricUnit = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: StravoColors.textMuted,
    letterSpacing: 0.8,
  );

  static const TextStyle metricLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: StravoColors.textMuted,
    letterSpacing: 1.2,
  );

  // Body Texts
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: StravoColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: StravoColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: StravoColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: StravoColors.textMuted,
  );
}
