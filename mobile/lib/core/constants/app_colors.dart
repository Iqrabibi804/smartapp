import 'package:flutter/material.dart';

/// Supported Pakistan Cultural Color Schemes
enum PakistanPalette {
  /// Deep flag green, terracotta brickwork & truck art orange (Recommended)
  heritageAndNature,

  /// Glacial alpine blue, cold desert sand & ice mint
  northernPeaksAndGlaciers,

  /// Bold cultural teal, truck art hot pink & bright chameli yellow
  vibrantTruckArt,
}

class AppColors {
  AppColors._();

  // Active default: Heritage & Nature (Recommended for Pakistan Tourism)
  static const Color primary = Color(0xFF006644); // Deep Flag Green
  static const Color primaryDark = Color(0xFF004D33);
  static const Color accent = Color(0xFFE65F2B); // Truck Art Terracotta / Orange

  static const Color background = Color(0xFFF9F9F6); // Warm Off-White
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1A2521); // Charcoal with green undertone
  static const Color textSecondary = Color(0xFF5C6B6B);

  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFE0A400);
  static const Color error = Color(0xFFD64545);

  // Dark mode
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ── 🎨 1. The Heritage & Nature Palette (Recommended) ──────────────────────
  static const Color heritageGreen = Color(0xFF006644);
  static const Color heritageTerracotta = Color(0xFFE65F2B);
  static const Color heritageOffWhite = Color(0xFFF9F9F6);
  static const Color heritageCharcoal = Color(0xFF1A2521);

  // ── 🏔️ 2. The Northern Peaks & Glaciers Palette ─────────────────────────────
  static const Color glacialBlue = Color(0xFF1D4ED8);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color desertGold = Color(0xFFF59E0B);
  static const Color iceMint = Color(0xFFF0FDFA);

  // ── 🛺 3. Vibrant Truck Art Palette ─────────────────────────────────────────
  static const Color truckArtTeal = Color(0xFF0D9488);
  static const Color truckArtMagenta = Color(0xFFDB2777);
  static const Color truckArtYellow = Color(0xFFFBBF24);

  // Compatibility aliases
  static const Color primaryTeal = primary;
  static const Color accentCoral = accent;
}
