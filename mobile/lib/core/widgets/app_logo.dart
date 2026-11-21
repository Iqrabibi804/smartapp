import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

/// Original SmartMap Punjab mark: a location pin holding a crescent and star.
/// Original artwork only — not derived from any state emblem or seal.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.size = 72, this.color, this.accent});

  final double size;
  final Color? color;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(
          color: color ?? Colors.white,
          accent: accent ?? AppTokens.heritageGold,
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.color, required this.accent});

  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final head = Offset(cx, s * 0.40);
    final r = s * 0.27;

    final pin = Path()
      ..addOval(Rect.fromCircle(center: head, radius: r))
      ..moveTo(cx - r * 0.60, head.dy + r * 0.55)
      ..lineTo(cx, s * 0.88)
      ..lineTo(cx + r * 0.60, head.dy + r * 0.55)
      ..close();

    canvas.drawPath(
      pin,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // Inner disc keeps the crescent readable against the pin fill.
    canvas.drawCircle(
      head,
      r * 0.78,
      Paint()
        ..color = color.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    final crescentOuter = Path()
      ..addOval(Rect.fromCircle(center: Offset(head.dx - r * 0.08, head.dy), radius: r * 0.52));
    final crescentCut = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(head.dx + r * 0.10, head.dy - r * 0.04), radius: r * 0.44),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, crescentOuter, crescentCut),
      Paint()
        ..color = accent
        ..style = PaintingStyle.fill,
    );

    _drawStar(
      canvas,
      Offset(head.dx + r * 0.40, head.dy - r * 0.34),
      r * 0.17,
      r * 0.07,
      accent,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double outer, double inner, Color paintColor) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = paintColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.accent != accent;
  }
}

/// Mark plus wordmark, used on splash and home header.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.markSize = 40,
    this.titleColor,
    this.taglineColor,
    this.showTagline = true,
    this.urduName = 'سمارٹ میپ پنجاب',
  });

  final double markSize;
  final Color? titleColor;
  final Color? taglineColor;
  final bool showTagline;
  final String urduName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogoMark(size: markSize),
        const SizedBox(height: 10),
        Text(
          'SmartMap Punjab',
          style: TextStyle(
            fontFamily: AppTokens.fontHeading,
            fontSize: markSize * 0.52,
            fontWeight: FontWeight.w700,
            color: titleColor ?? AppTokens.pakistanGreen,
            letterSpacing: -0.4,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            urduName,
            style: TextStyle(
              fontFamily: AppTokens.fontUrdu,
              fontSize: markSize * 0.30,
              color: taglineColor ?? AppTokens.heritageGold,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ],
    );
  }
}
