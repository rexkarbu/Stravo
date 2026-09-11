import 'package:flutter/material.dart';

/// Stravo Pro - Master Color Palette
/// Desain oleh: Ray (Lead UI/UX)
/// Palet tema Stealth Dark Neon & Glassmorphism yang dioptimalkan untuk layar OLED.
class StravoColors {
  StravoColors._();

  // Backgrounds (OLED Deep Dark)
  static const Color background = Color(0xFF0A0C10);
  static const Color backgroundSecondary = Color(0xFF12161F);
  static const Color surface = Color(0xFF161B24);
  static const Color surfaceElevated = Color(0xFF1F2633);

  // Glassmorphism Surfaces (dengan opacity untuk efek blur)
  static const Color glassSurface = Color(0xCC161B24); // ~80% opacity
  static const Color glassBorder = Color(0x1FFFFFFF); // ~12% white border

  // Brand Accents
  static const Color orangePrimary = Color(0xFFFF5500); // Stravo Pro Orange
  static const Color orangeGlow = Color(0x66FF5500); // Glow shadow

  // Cyber Gravel & Sport Accents
  static const Color cyberGreen = Color(0xFF00FF9D); // Gravel, GPS locked, Fast pace
  static const Color electricCyan = Color(0xFF00E5FF); // Segments, Ghost Pacer ahead
  static const Color neonYellow = Color(0xFFFFD600); // Moderate climb 5-8%
  static const Color neonPink = Color(0xFFFF0055); // Stop, extreme climb >13%

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B9C6);
  static const Color textMuted = Color(0xFF6B7787);
  static const Color textDisabled = Color(0xFF424B57);

  // Status & Telemetry Indicators
  static const Color gpsActive = Color(0xFF00FF9D);
  static const Color gpsSearching = Color(0xFFFFD600);
  static const Color gpsLost = Color(0xFFFF0055);

  // Gradient Presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5500), Color(0xFFFF7722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF00FF9D), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
