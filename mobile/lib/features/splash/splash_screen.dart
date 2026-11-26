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
                colors: [Color(0xFFF0C66B), Color(0xFF1B6A3A), Color(0xFF06371B), Color(0xFF021F0E)],
                stops: [0.0, 0.24, 0.58, 1.0],
              ),
            ),
          ),
          const CustomPaint(painter: _WelcomeBackdropPainter()),
          // Separate footer zone with a dark fade so it never crosses the skyline.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 92,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF021F0E).withValues(alpha: 0),
                      const Color(0xFF021F0E).withValues(alpha: .94),
                      const Color(0xFF021F0E),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 25,
            child: SafeArea(
              top: false,
              child: Text(
                'Independent tourism & navigation guide  |  v1.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFA3B8AA).withValues(alpha: .92),
                  fontSize: 10,
                  letterSpacing: .15,
                ),
              ),
            ),
          ),
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
                                  color: Colors.black26,
                                  border: Border.all(color: _gold, width: 1),
                                  borderRadius: BorderRadius.circular(20),
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
                          _WelcomePinMark(size: logoSize),
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .09),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white.withValues(alpha: .22)),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 18, offset: Offset(0, 5)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_city_rounded, color: _goldLight, size: 17),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    _urdu ? '81 شہر' : '81 Cities',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Container(width: 1, height: 18, margin: const EdgeInsets.symmetric(horizontal: 9), color: Colors.white30),
                                const Icon(Icons.offline_pin_rounded, color: _goldLight, size: 17),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    _urdu ? 'آف لائن رہنمائی' : 'Offline-ready',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
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
                          SizedBox(height: compact ? 155 : 190),
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


class _WelcomePinMark extends StatelessWidget {
  const _WelcomePinMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _SolidWelcomePinPainter()),
      );
}

class _SolidWelcomePinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final center = Offset(w * .5, w * .39);
    final radius = w * .285;
    // One continuous, closed teardrop silhouette: rounded head and tapered tip.
    final pin = Path()
      ..moveTo(center.dx, w * .96)
      ..cubicTo(w * .43, w * .79, w * .18, w * .62, w * .18, center.dy)
      ..cubicTo(w * .18, w * .22, w * .32, w * .105, center.dx, w * .105)
      ..cubicTo(w * .68, w * .105, w * .82, w * .22, w * .82, center.dy)
      ..cubicTo(w * .82, w * .62, w * .57, w * .79, center.dx, w * .96)
      ..close();

    canvas.drawPath(
      pin,
      Paint()
        ..color = Colors.black.withValues(alpha: .35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * .055)
        ..style = PaintingStyle.fill,
    );
    final bounds = Rect.fromLTWH(w * .12, w * .08, w * .76, w * .86);
    canvas.drawPath(
      pin,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF4F7F5), Color(0xFFDCE5DF)],
          stops: [0, .58, 1],
        ).createShader(bounds),
    );
    canvas.save();
    canvas.clipPath(pin);
    canvas.drawOval(
      Rect.fromLTWH(w * .18, w * .05, w * .48, w * .26),
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: .9), Colors.white.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(w * .18, w * .05, w * .48, w * .26)),
    );
    canvas.restore();
    canvas.drawPath(
      pin,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withValues(alpha: .95),
    );

    canvas.drawCircle(
      center,
      radius * .73,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-.35, -.45),
          colors: [Color(0xFF0B512D), Color(0xFF06371B), Color(0xFF021F0E)],
        ).createShader(Rect.fromCircle(center: center, radius: radius * .73)),
    );
    final outer = Path()
      ..addOval(Rect.fromCircle(center: Offset(center.dx - radius * .08, center.dy), radius: radius * .48));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: Offset(center.dx + radius * .15, center.dy - radius * .08), radius: radius * .40));
    final crescent = Path.combine(PathOperation.difference, outer, cut);
    canvas.drawPath(crescent, Paint()..color = Colors.white);
    final starCenter = Offset(center.dx + radius * .39, center.dy - radius * .34);
    final star = Path();
    for (var i = 0; i < 10; i++) {
      final rr = i.isEven ? radius * .16 : radius * .068;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = Offset(starCenter.dx + rr * math.cos(a), starCenter.dy + rr * math.sin(a));
      if (i == 0) {
        star.moveTo(p.dx, p.dy);
      } else {
        star.lineTo(p.dx, p.dy);
      }
    }
    star.close();
    canvas.drawPath(star, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WelcomeBackdropPainter extends CustomPainter {
  const _WelcomeBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final contour = Paint()
      ..color = const Color(0xFFC5A059).withValues(alpha: .09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .75;
    // Organic elevation rings with irregular Bézier contours.
    for (var group = 0; group < 5; group++) {
      final cx = size.width * (group.isEven ? .18 : .78);
      final cy = size.height * (.08 + group * .105);
      for (var ring = 0; ring < 6; ring++) {
        final rx = size.width * (.10 + ring * .052);
        final ry = size.height * (.025 + ring * .014);
        final path = Path();
        for (var step = 0; step <= 48; step++) {
          final t = step * math.pi * 2 / 48;
          final irregular = 1 + .11 * math.sin(t * 3 + group) + .055 * math.cos(t * 5 - ring);
          final x = cx + math.cos(t) * rx * irregular;
          final y = cy + math.sin(t) * ry * irregular + math.sin(t * 2 + group) * size.height * .006;
          if (step == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, contour);
      }
    }

    final frame = Paint()
      ..color = _gold.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final frameRect = Rect.fromLTWH(16, 16, size.width - 32, size.height - 32);
    // Keep the inset frame but omit its full-width top stroke so it doesn't
    // visually underline or compete with the language control.
    canvas.drawLine(Offset(frameRect.left, frameRect.top), Offset(frameRect.left, frameRect.bottom), frame);
    canvas.drawLine(Offset(frameRect.right, frameRect.top), Offset(frameRect.right, frameRect.bottom), frame);
    canvas.drawLine(Offset(frameRect.left, frameRect.bottom), Offset(frameRect.right, frameRect.bottom), frame);

    final ornament = Paint()
      ..color = _gold.withValues(alpha: .82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    for (final corner in [
      const Offset(16, 16),
      Offset(size.width - 16, 16),
      Offset(16, size.height - 16),
      Offset(size.width - 16, size.height - 16),
    ]) {
      final sx = corner.dx < size.width / 2 ? 1.0 : -1.0;
      final sy = corner.dy < size.height / 2 ? 1.0 : -1.0;
      for (var n = 0; n < 3; n++) {
        final r = 12.0 + n * 8;
        final path = Path()
          ..moveTo(corner.dx, corner.dy + sy * r)
          ..lineTo(corner.dx + sx * r, corner.dy)
          ..lineTo(corner.dx + sx * r * 1.35, corner.dy + sy * r * .35)
          ..lineTo(corner.dx + sx * r * .35, corner.dy + sy * r * 1.35)
          ..close();
        canvas.drawPath(path, ornament);
      }
      canvas.drawCircle(corner, 2.6, Paint()..color = _gold);
    }
    for (final x in [16.0, size.width - 16]) {
      final cy = size.height * .5;
      final diamond = Path()
        ..moveTo(x, cy - 9)
        ..lineTo(x + (x < size.width / 2 ? 9 : -9), cy)
        ..lineTo(x, cy + 9)
        ..lineTo(x + (x < size.width / 2 ? -9 : 9), cy)
        ..close();
      canvas.drawPath(diamond, Paint()..color = _gold);
    }

    // Detailed, low-contrast architectural line art in a dedicated bottom band.
    final art = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final base = size.height * .875;
    final unit = size.width / 390;

    // Badshahi Mosque: four minarets, onion domes, arched entrances.
    final mosqueLeft = size.width * .035;
    final mosqueWidth = size.width * .39;
    canvas.drawLine(Offset(mosqueLeft, base), Offset(mosqueLeft + mosqueWidth, base), art);
    for (final x in [mosqueLeft + mosqueWidth * .10, mosqueLeft + mosqueWidth * .90]) {
      _minaret(canvas, x, base, size.height * .145, art);
    }
    _dome(canvas, Offset(mosqueLeft + mosqueWidth * .5, base - size.height * .065), mosqueWidth * .16, art);
    _dome(canvas, Offset(mosqueLeft + mosqueWidth * .29, base - size.height * .035), mosqueWidth * .105, art);
    _dome(canvas, Offset(mosqueLeft + mosqueWidth * .71, base - size.height * .035), mosqueWidth * .105, art);
    final hall = Rect.fromLTWH(mosqueLeft + mosqueWidth * .20, base - size.height * .075, mosqueWidth * .60, size.height * .075);
    canvas.drawRect(hall, art);
    for (var a = 0; a < 5; a++) {
      final ax = hall.left + hall.width * (a + .5) / 5;
      final aw = hall.width * .075;
      final ah = hall.height * .66;
      final arch = Path()
        ..moveTo(ax - aw, base)
        ..lineTo(ax - aw, base - ah * .55)
        ..quadraticBezierTo(ax, base - ah * 1.25, ax + aw, base - ah * .55)
        ..lineTo(ax + aw, base);
      canvas.drawPath(arch, art);
    }

    // Minar-e-Pakistan with its flared, petal-like platform and tapered shaft.
    final mx = size.width * .515;
    final mh = size.height * .165;
    final platform = Path()
      ..moveTo(mx - 28 * unit, base)
      ..quadraticBezierTo(mx - 35 * unit, base - 7 * unit, mx - 24 * unit, base - 13 * unit)
      ..quadraticBezierTo(mx - 17 * unit, base - 8 * unit, mx - 11 * unit, base - 17 * unit)
      ..lineTo(mx - 7 * unit, base - mh * .78)
      ..lineTo(mx - 4 * unit, base - mh)
      ..lineTo(mx + 4 * unit, base - mh)
      ..lineTo(mx + 7 * unit, base - mh * .78)
      ..lineTo(mx + 11 * unit, base - 17 * unit)
      ..quadraticBezierTo(mx + 17 * unit, base - 8 * unit, mx + 24 * unit, base - 13 * unit)
      ..quadraticBezierTo(mx + 35 * unit, base - 7 * unit, mx + 28 * unit, base)
      ..close();
    canvas.drawPath(platform, art);
    for (var k = 1; k < 7; k++) {
      final yy = base - mh * k / 8;
      final inset = (k * 1.8) * unit;
      canvas.drawLine(Offset(mx - 9 * unit + inset, yy), Offset(mx + 9 * unit - inset, yy), art);
    }
    canvas.drawLine(Offset(mx, base - mh), Offset(mx, base - mh * .82), art);

    // Rohtas Fort: crenellated wall, bastion towers and arched gate.
    final fortX = size.width * .67;
    final fortW = size.width * .29;
    final fortTop = base - size.height * .09;
    canvas.drawLine(Offset(fortX, base), Offset(fortX + fortW, base), art);
    final wall = Path()
      ..moveTo(fortX, base)
      ..lineTo(fortX, fortTop + 7)
      ..lineTo(fortX + fortW, fortTop + 7)
      ..lineTo(fortX + fortW, base);
    canvas.drawPath(wall, art);
    for (var b = 0; b < 9; b++) {
      final bx = fortX + b * fortW / 9;
      canvas.drawRect(Rect.fromLTWH(bx, fortTop, fortW / 15, 8 * unit), art);
    }
    for (final tx in [fortX + 4, fortX + fortW - 22]) {
      final tower = RRect.fromRectAndRadius(
        Rect.fromLTWH(tx, fortTop - 10, 18, base - fortTop + 10),
        Radius.circular(5 * unit),
      );
      canvas.drawRRect(tower, art);
      canvas.drawLine(Offset(tx - 2, fortTop - 10), Offset(tx + 20, fortTop - 10), art);
      canvas.drawLine(Offset(tx + 3, fortTop + 5), Offset(tx + 3, base - 2), art);
    }
    final gateX = fortX + fortW * .48;
    final gate = Path()
      ..moveTo(gateX - 9 * unit, base)
      ..lineTo(gateX - 9 * unit, base - 24 * unit)
      ..quadraticBezierTo(gateX, base - 42 * unit, gateX + 9 * unit, base - 24 * unit)
      ..lineTo(gateX + 9 * unit, base)
      ..close();
    canvas.drawPath(gate, art);
  }

  void _dome(Canvas canvas, Offset base, double radius, Paint paint) {
    final path = Path()
      ..moveTo(base.dx - radius, base.dy)
      ..cubicTo(base.dx - radius * 1.05, base.dy - radius * .72, base.dx - radius * .45, base.dy - radius * 1.35, base.dx, base.dy - radius * 1.42)
      ..cubicTo(base.dx + radius * .45, base.dy - radius * 1.35, base.dx + radius * 1.05, base.dy - radius * .72, base.dx + radius, base.dy)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(base.dx, base.dy - radius * 1.42), Offset(base.dx, base.dy - radius * 1.62), paint);
    canvas.drawLine(Offset(base.dx - radius * .85, base.dy - radius * .08), Offset(base.dx + radius * .85, base.dy - radius * .08), paint);
  }

  void _minaret(Canvas canvas, double x, double base, double height, Paint paint) {
    final path = Path()
      ..moveTo(x - 5, base)
      ..lineTo(x - 3, base - height * .18)
      ..lineTo(x - 6, base - height * .22)
      ..lineTo(x - 3, base - height * .27)
      ..lineTo(x - 2.5, base - height * .90)
      ..lineTo(x - 5, base - height * .94)
      ..lineTo(x, base - height)
      ..lineTo(x + 5, base - height * .94)
      ..lineTo(x + 2.5, base - height * .90)
      ..lineTo(x + 3, base - height * .27)
      ..lineTo(x + 6, base - height * .22)
      ..lineTo(x + 3, base - height * .18)
      ..lineTo(x + 5, base)
      ..close();
    canvas.drawPath(path, paint);
    for (final fraction in [.24, .68, .90]) {
      final y = base - height * fraction;
      canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), paint);
    }
    canvas.drawLine(Offset(x, base - height), Offset(x, base - height * .94), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
