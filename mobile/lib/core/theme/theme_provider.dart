import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';

/// Manages application-wide theme mode (Light, Dark, or System default).
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Manages cultural Pakistan theme palette
class PakistanPaletteNotifier extends StateNotifier<PakistanPalette> {
  PakistanPaletteNotifier() : super(PakistanPalette.heritageAndNature);

  void setPalette(PakistanPalette palette) {
    state = palette;
  }
}

final pakistanPaletteProvider = StateNotifierProvider<PakistanPaletteNotifier, PakistanPalette>((ref) {
  return PakistanPaletteNotifier();
});
