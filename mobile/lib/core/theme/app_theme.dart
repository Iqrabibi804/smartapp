import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Single SmartMap Punjab theme (light + dark) built from [AppTokens].
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    const primary = AppTokens.pakistanGreen;
    const onPrimary = Colors.white;
    final scaffold = isDark ? AppTokens.scaffoldDark : AppTokens.scaffold;
    final surface = isDark ? AppTokens.surfaceDark : AppTokens.surface;
    final border = isDark ? AppTokens.borderDark : AppTokens.border;
    final textPrimary = isDark ? AppTokens.textPrimaryDark : AppTokens.textPrimary;
    final textSecondary = isDark ? AppTokens.textSecondaryDark : AppTokens.textSecondary;

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: AppTokens.heritageGold,
      onSecondary: const Color(0xFF2A2113),
      surface: surface,
      onSurface: textPrimary,
      outline: border,
      error: AppTokens.alertRed,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      cardColor: surface,
      dividerColor: border,
      fontFamily: AppTokens.fontBody,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, textPrimary, textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: AppTokens.fontHeading,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 3,
        height: 68,
        indicatorColor: primary.withValues(alpha: isDark ? 0.35 : 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? primary : textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? primary : textSecondary,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: primary.withValues(alpha: 0.4),
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: const TextStyle(
            fontFamily: AppTokens.fontHeading,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: border),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppTokens.surfaceDark : AppTokens.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
    );
  }

  static TextTheme _textTheme(
    TextTheme base,
    Color primaryColor,
    Color secondaryColor,
  ) {
    TextStyle heading(TextStyle? style, double size, FontWeight weight) =>
        (style ?? const TextStyle()).copyWith(
          fontFamily: AppTokens.fontHeading,
          fontSize: size,
          fontWeight: weight,
          color: primaryColor,
          height: 1.25,
        );

    TextStyle body(TextStyle? style, double size, Color color) =>
        (style ?? const TextStyle()).copyWith(
          fontFamily: AppTokens.fontBody,
          fontSize: size,
          color: color,
          height: 1.45,
        );

    return base.copyWith(
      displaySmall: heading(base.displaySmall, 32, FontWeight.w700),
      headlineMedium: heading(base.headlineMedium, 26, FontWeight.w700),
      headlineSmall: heading(base.headlineSmall, 22, FontWeight.w600),
      titleLarge: heading(base.titleLarge, 20, FontWeight.w600),
      titleMedium: heading(base.titleMedium, 16, FontWeight.w600),
      titleSmall: heading(base.titleSmall, 14, FontWeight.w600),
      bodyLarge: body(base.bodyLarge, 16, primaryColor),
      bodyMedium: body(base.bodyMedium, 14, primaryColor),
      bodySmall: body(base.bodySmall, 12, secondaryColor),
      labelLarge: body(base.labelLarge, 14, primaryColor).copyWith(fontWeight: FontWeight.w500),
      labelMedium: body(base.labelMedium, 12, secondaryColor),
    );
  }
}
