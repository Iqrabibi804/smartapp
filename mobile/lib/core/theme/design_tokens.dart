import 'package:flutter/material.dart';

/// SmartMap Punjab design tokens — single national identity.
/// Pakistan Green leads; heritage gold is a restrained accent;
/// alert red is reserved for emergencies and errors.
class AppTokens {
  AppTokens._();

  static const Color pakistanGreen = Color(0xFF01411C);
  static const Color pakistanGreenDark = Color(0xFF012E13);
  static const Color heritageGold = Color(0xFFC5A66A);
  static const Color alertRed = Color(0xFFB91C1C);
  static const Color scaffold = Color(0xFFF4F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFB45309);

  static const Color scaffoldDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const String fontHeading = 'Poppins';
  static const String fontBody = 'Roboto';
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

  static BorderRadius get card => BorderRadius.circular(md);
  static BorderRadius get sheet => BorderRadius.circular(xl);
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
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
