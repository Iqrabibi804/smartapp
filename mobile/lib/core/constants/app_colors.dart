import 'package:flutter/material.dart';

/// Canonical SmartMap Punjab color palette (single identity).
///
/// Values mirror [AppTokens] in `core/theme/design_tokens.dart`. This file
/// keeps the historical [AppColors] API so existing screens compile unchanged.
class AppColors {
  AppColors._();

  // Core
  static const Color primary = Color(0xFF01411C); // Pakistan Green
  static const Color primaryDark = Color(0xFF012E13);
  static const Color accent = Color(0xFFC5A66A); // Heritage gold (restrained)

  static const Color background = Color(0xFFF4F6F2);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);
  static const Color error = Color(0xFFB91C1C); // Alert red — alerts/errors only

  // Dark mode
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Compatibility aliases
  static const Color primaryTeal = primary;
  static const Color accentCoral = accent;

  // Legacy palette names retained so older imports keep compiling.
  // They intentionally resolve to the canonical identity.
  static const Color heritageGreen = primary;
  static const Color heritageTerracotta = accent;
  static const Color heritageOffWhite = background;
  static const Color heritageCharcoal = textPrimary;

  static const Color glacialBlue = primary;
  static const Color skyBlue = primary;
  static const Color desertGold = accent;
  static const Color iceMint = background;

  static const Color truckArtTeal = primary;
  static const Color truckArtMagenta = accent;
  static const Color truckArtYellow = accent;
}
