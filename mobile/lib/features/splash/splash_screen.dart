import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/app_logo.dart';
import '../auth/services/auth_providers.dart';
import '../home/screens/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    final started = DateTime.now();
    try {
      // Strict timeout so the user never gets stuck on splash.
      await ref
          .read(authControllerProvider.notifier)
          .restoreSession()
          .timeout(const Duration(milliseconds: 2000), onTimeout: () {});
    } catch (_) {}

    // Brief brand moment, at least 1.2s even if session restore is instant.
    const minimum = Duration(milliseconds: 1200);
    final elapsed = DateTime.now().difference(started);
    if (elapsed < minimum) {
      await Future.delayed(minimum - elapsed);
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppTokens.pakistanGreenDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.splash),
          ),
          // Soft light source near the top, suggesting depth without motion.
          Positioned(
            top: -media.size.height * 0.18,
            right: -media.size.width * 0.25,
            child: Container(
              width: media.size.width * 0.9,
              height: media.size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                const AppLogoMark(size: 108),
                const SizedBox(height: 24),
                const Text(
                  'SmartMap Punjab',
                  style: TextStyle(
                    fontFamily: AppTokens.fontHeading,
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'سمارٹ میپ پنجاب',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppTokens.fontUrdu,
                    color: AppTokens.heritageGold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 2,
                  decoration: const BoxDecoration(gradient: AppGradients.goldRule),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Explore Punjab. Travel with Confidence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTokens.fontBody,
                    color: Colors.white70,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '81 cities · Offline-ready guidance · Honest information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
                const Spacer(flex: 2),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      minHeight: 3,
                      backgroundColor: Color(0x33FFFFFF),
                      valueColor: AlwaysStoppedAnimation(AppTokens.heritageGold),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Independent guide — not affiliated with any government body.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
