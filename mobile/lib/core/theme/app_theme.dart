import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Supports light and dark mode cleanly with unified high-contrast colors.
class AppTheme {
  AppTheme._();

  static Color primaryFor(PakistanPalette palette) {
    switch (palette) {
      case PakistanPalette.heritageAndNature:
        return const Color(0xFF006644); // Deep flag green
      case PakistanPalette.northernPeaksAndGlaciers:
        return const Color(0xFF1D4ED8); // Glacial alpine blue
      case PakistanPalette.vibrantTruckArt:
        return const Color(0xFF0D9488); // Truck art teal
    }
  }

  static Color accentFor(PakistanPalette palette) {
    switch (palette) {
      case PakistanPalette.heritageAndNature:
        return const Color(0xFFE65F2B); // Terracotta
      case PakistanPalette.northernPeaksAndGlaciers:
        return const Color(0xFF0284C7); // Glacial cyan
      case PakistanPalette.vibrantTruckArt:
        return const Color(0xFFDB2777); // Truck art magenta
    }
  }

  static ThemeData lightTheme([PakistanPalette palette = PakistanPalette.heritageAndNature]) {
    final primary = primaryFor(palette);
    final accent = accentFor(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: Colors.white,
        error: AppColors.error,
      ),
      textTheme: _textTheme(const Color(0xFF0F172A), const Color(0xFF64748B)),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: Color(0xFF64748B));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: Color(0xFF64748B), fontSize: 12);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  static ThemeData darkTheme([PakistanPalette palette = PakistanPalette.heritageAndNature]) {
    final primary = primaryFor(palette);
    final accent = accentFor(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.surfaceDark,
      dividerColor: const Color(0xFF334155),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      textTheme: _textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: primary.withValues(alpha: 0.25),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 12);
          }
          return const TextStyle(color: Color(0xFF94A3B8), fontSize: 12);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
    );
  }

  static ThemeData get light => lightTheme();
  static ThemeData get dark => darkTheme();

  static TextTheme _textTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 26),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 20),
      bodyLarge: TextStyle(color: primaryColor, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryColor, fontSize: 14),
    );
  }
}
