import 'package:flutter/material.dart';

/// SmartMap Punjab design tokens — single national identity.
/// Pakistan Green leads; heritage gold is a restrained accent;
/// alert red is reserved for emergencies and errors.
class AppTokens {
  AppTokens._();

  static const Color pakistanGreen = Color(0xFF01411C);
  static const Color pakistanGreenDark = Color(0xFF012E13);
  static const Color heritageGold = Color(0xFFC5A66A);
  static const Color alertRed = Color(0xFFDC2626);
  static const Color scaffold = Color(0xFFF8F9FA);

  // Unified light theme: alabaster canvas, royal emerald, warm amber
  // and slate typography. Pastels are restricted to small icon tiles.
  static const Color dashboardBg = Color(0xFFF8F9FA);
  static const Color emerald = Color(0xFF0E5A36);
  static const Color emeraldHover = Color(0xFF0A4328);
  static const Color emeraldTint = Color(0xFFECFDF5);
  static const Color emeraldBorder = Color(0xFFA7F3D0);
  static const Color emeraldDeep = Color(0xFF0A3E24);
  static const Color gold = Color(0xFFD97706);
  static const Color goldHover = Color(0xFFB45309);
  static const Color goldTint = Color(0xFFFFFBEB);
  static const Color goldBorder = Color(0xFFFDE68A);
  static const Color multaniBlue = Color(0xFF1D4ED8);
  static const Color cardBorderWarm = Color(0xFFE2E8F0);
  static const Color pastelMint = Color(0xFFECFDF5);
  static const Color pastelGold = Color(0xFFFFFBEB);
  static const Color pastelBlue = Color(0xFFEFF6FF);
  static const Color pastelRose = Color(0xFFFEF2F2);
  static const Color pastelLilac = Color(0xFFF5F3FF);
  static const Color pastelTeal = Color(0xFFF0FDFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);

  static const Color scaffoldDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const String fontHeading = 'PlusJakartaSans';
  static const String fontBody = 'PlusJakartaSans';
  static const String fontUrdu = 'NotoNastaliqUrdu';
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get sheet => BorderRadius.circular(xl);
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get hover => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.14),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
}

class AppGradients {
  AppGradients._();

  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF012E13), Color(0xFF01411C)],
  );

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF01411C), Color(0xFF0A5C2A)],
  );

  static const LinearGradient goldRule = LinearGradient(
    colors: [Color(0xFFC5A66A), Color(0xFFE3D2AC), Color(0xFFC5A66A)],
  );
}
