import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/app_logo.dart';
import '../auth/services/auth_providers.dart';
import '../home/screens/home_screen.dart';

const _gold = Color(0xFFD4AF37);
const _goldLight = Color(0xFFE5C158);
const _champagne = Color(0xFFD8C798);
const _pine = Color(0xFF0A2414);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _urdu = false;

  @override
  void initState() {
    super.initState();
    // Restore an existing session quietly; the user still controls when to enter.
    Future.microtask(() async {
      try {
        await ref
            .read(authControllerProvider.notifier)
            .restoreSession()
            .timeout(const Duration(seconds: 2), onTimeout: () {});
      } catch (_) {}
    });
  }

  void _enterApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFF021F0E),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF06371B), Color(0xFF021F0E)],
              ),
            ),
          ),
          const CustomPaint(painter: _WelcomeBackdropPainter()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 720;
                final logoSize = (constraints.maxHeight * (compact ? .17 : .205))
                    .clamp(112.0, 174.0);
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(26, 8, 26, 18),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => setState(() => _urdu = !_urdu),
                              child: Container(
                                height: 34,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xCC032713),
                                  border: Border.all(color: _gold.withValues(alpha: .75)),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black26, blurRadius: 10),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _urdu ? 'EN  |  اردو' : 'اردو  |  EN',
                                    style: const TextStyle(
                                      color: _goldLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: compact ? 16 : 28),
                          AppLogoMark3D(size: logoSize),
                          SizedBox(height: compact ? 12 : 20),
                          Text(
                            'SmartMap Punjab',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTokens.fontHeading,
                              color: Colors.white,
                              fontSize: compact ? 29 : 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              shadows: const [
                                Shadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 3)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'سمارٹ میپ پنجاب',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTokens.fontUrdu,
                              color: _goldLight,
                              fontSize: compact ? 23 : 27,
                              shadows: const [
                                Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 60,
                            height: 1.5,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [_gold, _goldLight, _gold]),
                            ),
                          ),
                          SizedBox(height: compact ? 14 : 20),
                          Text(
                            _urdu ? 'پنجاب دریافت کریں۔ اعتماد سے سفر کریں۔' : 'Explore Punjab. Travel with confidence.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .96),
                              fontSize: compact ? 14 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            _urdu
                                ? '81 شہر  •  آف لائن رہنمائی  •  درست معلومات'
                                : '81 cities  •  Offline-ready guidance  •  Honest information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _champagne.withValues(alpha: .95),
                              fontSize: compact ? 10.5 : 12,
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: compact ? 20 : 30),
                          SizedBox(
                            width: 220,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xFFE6C15A), Color(0xFFB88A2E)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: _gold.withValues(alpha: .24),
                                    blurRadius: 18,
                                    offset: const Offset(0, 5),
                                  ),
                                  const BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: _enterApp,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _urdu ? 'پنجاب دریافت کریں' : 'Explore Punjab',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: _pine,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 27,
                                          height: 27,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: _pine.withValues(alpha: .8), width: 1.5),
                                          ),
                                          child: const Icon(Icons.arrow_forward_rounded, size: 17, color: _pine),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: compact ? 150 : 190),
                          Text(
                            'Independent tourism & navigation guide  |  v1.0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFA3B8AA).withValues(alpha: .9),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeBackdropPainter extends CustomPainter {
  const _WelcomeBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final contour = Paint()
      ..color = const Color(0xFFC5A059).withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    // Fine, flowing contour-map lines across the upper portion.
    for (var i = 0; i < 15; i++) {
      final path = Path();
      final y = size.height * (.02 + i * .038);
      path.moveTo(-size.width * .08, y);
      for (var x = 0.0; x <= size.width * 1.1; x += size.width / 8) {
        final wave = math.sin((x / size.width * 2.2) + i * .53) * size.height * .025;
        final bend = math.cos((x / size.width * 1.7) - i * .31) * size.height * .012;
        path.lineTo(x, y + wave + bend);
      }
      canvas.drawPath(path, contour);
    }

    // Inset gold frame.
    final frame = Paint()
      ..color = _gold.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rect = Rect.fromLTWH(16, 16, size.width - 32, size.height - 32);
    canvas.drawRect(rect, frame);

    // Mughal-inspired geometric corner ornaments and midpoint diamonds.
    final ornament = Paint()
      ..color = _gold.withValues(alpha: .82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final corner in [
      const Offset(16, 16),
      Offset(size.width - 16, 16),
      Offset(16, size.height - 16),
      Offset(size.width - 16, size.height - 16),
    ]) {
      final sx = corner.dx < size.width / 2 ? 1.0 : -1.0;
      final sy = corner.dy < size.height / 2 ? 1.0 : -1.0;
      for (var n = 0; n < 3; n++) {
        final r = 12.0 + n * 9;
        final path = Path()
          ..moveTo(corner.dx, corner.dy + sy * r)
          ..lineTo(corner.dx + sx * r, corner.dy)
          ..lineTo(corner.dx + sx * r * 1.35, corner.dy + sy * r * .35)
          ..lineTo(corner.dx + sx * r * .35, corner.dy + sy * r * 1.35)
          ..close();
        canvas.drawPath(path, ornament);
      }
      canvas.drawCircle(corner, 3, Paint()..color = _gold);
    }
    for (final x in [16.0, size.width - 16]) {
      final cy = size.height * .5;
      final diamond = Path()
        ..moveTo(x, cy - 10)
        ..lineTo(x + (x < size.width / 2 ? 10 : -10), cy)
        ..lineTo(x, cy + 10)
        ..lineTo(x + (x < size.width / 2 ? -10 : 10), cy)
        ..close();
      canvas.drawPath(diamond, Paint()..color = _gold);
    }

    // Landmark line-art silhouettes at the bottom: mosque, Minar and fort.
    final skyline = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: .30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final base = size.height * .91;
    final left = size.width * .04;
    final w = size.width * .36;
    // Badshahi Mosque: central dome, smaller domes and minarets.
    canvas.drawLine(Offset(left, base), Offset(left + w, base), skyline);
    _drawMinaret(canvas, Offset(left + w * .12, base), size.height * .13, skyline);
    _drawMinaret(canvas, Offset(left + w * .88, base), size.height * .13, skyline);
    _drawDome(canvas, Offset(left + w * .50, base - size.height * .075), w * .18, skyline);
    _drawDome(canvas, Offset(left + w * .28, base - size.height * .045), w * .12, skyline);
    _drawDome(canvas, Offset(left + w * .72, base - size.height * .045), w * .12, skyline);
    canvas.drawRect(Rect.fromLTWH(left + w * .22, base - size.height * .07, w * .56, size.height * .07), skyline);
    // Minar-e-Pakistan.
    final mx = size.width * .51;
    final mh = size.height * .19;
    final minar = Path()
      ..moveTo(mx - 20, base)
      ..lineTo(mx - 11, base - mh * .18)
      ..lineTo(mx - 7, base - mh * .78)
      ..lineTo(mx - 4, base - mh)
      ..lineTo(mx + 4, base - mh)
      ..lineTo(mx + 7, base - mh * .78)
      ..lineTo(mx + 11, base - mh * .18)
      ..lineTo(mx + 20, base)
      ..close();
    canvas.drawPath(minar, skyline);
    for (var j = 1; j < 6; j++) {
      final yy = base - mh * (j / 7);
      canvas.drawLine(Offset(mx - 9 + j * 1.2, yy), Offset(mx + 9 - j * 1.2, yy), skyline);
    }
    canvas.drawLine(Offset(mx, base - mh), Offset(mx, base - mh * .82), skyline);
    // Rohtas Fort: battlements, wall and rounded towers.
    final fx = size.width * .67;
    final fw = size.width * .29;
    final fy = base - size.height * .095;
    canvas.drawRect(Rect.fromLTWH(fx, fy, fw, base - fy), skyline);
    for (var j = 0; j < 8; j++) {
      canvas.drawRect(Rect.fromLTWH(fx + j * fw / 8, fy - 5, fw / 12, 7), skyline);
    }
    for (final tx in [fx + 5, fx + fw - 21]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(tx, fy - 12, 17, base - fy + 12), const Radius.circular(5)),
        skyline,
      );
      canvas.drawLine(Offset(tx - 2, fy - 12), Offset(tx + 19, fy - 12), skyline);
    }
    // Subtle baseline and ground contours.
    canvas.drawLine(Offset(0, base + 5), Offset(size.width, base + 5), skyline);
    canvas.drawLine(Offset(0, base + 11), Offset(size.width, base + 11), skyline);
  }

  void _drawDome(Canvas canvas, Offset base, double radius, Paint paint) {
    final path = Path()
      ..moveTo(base.dx - radius, base.dy)
      ..quadraticBezierTo(base.dx - radius * .9, base.dy - radius * 1.3, base.dx, base.dy - radius * 1.35)
      ..quadraticBezierTo(base.dx + radius * .9, base.dy - radius * 1.3, base.dx + radius, base.dy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(base.dx, base.dy - radius * 1.35), Offset(base.dx, base.dy - radius * 1.55), paint);
  }

  void _drawMinaret(Canvas canvas, Offset base, double height, Paint paint) {
    final x = base.dx;
    final path = Path()
      ..moveTo(x - 5, base.dy)
      ..lineTo(x - 3, base.dy - height * .75)
      ..lineTo(x - 7, base.dy - height * .75)
      ..lineTo(x - 4, base.dy - height * .82)
      ..lineTo(x - 3, base.dy - height)
      ..lineTo(x + 3, base.dy - height)
      ..lineTo(x + 4, base.dy - height * .82)
      ..lineTo(x + 7, base.dy - height * .75)
      ..lineTo(x + 3, base.dy - height * .75)
      ..lineTo(x + 5, base.dy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(x, base.dy - height), Offset(x, base.dy - height * .92), paint);
    canvas.drawLine(Offset(x - 5, base.dy - height * .72), Offset(x + 5, base.dy - height * .72), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
