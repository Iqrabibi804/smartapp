import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: SmartMapApp()));
}

class SmartMapApp extends ConsumerWidget {
  const SmartMapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final palette = ref.watch(pakistanPaletteProvider);

    return MaterialApp(
      title: 'SmartMap AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(palette),
      darkTheme: AppTheme.darkTheme(palette),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
