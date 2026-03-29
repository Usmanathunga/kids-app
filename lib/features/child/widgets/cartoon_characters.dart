import 'dart:math';
import 'package:flutter/material.dart';

/// Drops 4 animated cartoon characters into the dashboard Stack.
class CartoonCharacters extends StatefulWidget {
  const CartoonCharacters({super.key});

  @override
  State<CartoonCharacters> createState() => _CartoonCharactersState();
}

class _CartoonCharactersState extends State<CartoonCharacters>
    with TickerProviderStateMixin {
  late final AnimationController _bob;    // sun bob
  late final AnimationController _bounce; // star bounce
  late final AnimationController _float;  // cloud drift
  late final AnimationController _wiggle; // bee wiggle

  @override
  void initState() {
    super.initState();
    _bob    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
    _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _float  = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat(reverse: true);
    _wiggle = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bob.dispose();
    _bounce.dispose();
    _float.dispose();
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ease = CurvedAnimation(parent: _bob, curve: Curves.easeInOut);
    final bounceEase = CurvedAnimation(parent: _bounce, curve: Curves.easeInOut);
    final floatEase  = CurvedAnimation(parent: _float,  curve: Curves.easeInOut);
    final wiggleEase = CurvedAnimation(parent: _wiggle, curve: Curves.easeInOut);

    return Stack(
      children: [
        // ── Sun (top-right, bobs up/down) ──────────────────────────
        AnimatedBuilder(
          animation: ease,
          builder: (_, child) => Positioned(
            top: 14 + ease.value * 14,
            right: -14,
            child: Opacity(opacity: 0.90, child: child),
          ),
          child: CustomPaint(
            painter: _SunPainter(),
            size: const Size(88, 88),
          ),
        ),

        // ── Star kid (left edge, bounces) ──────────────────────────
        AnimatedBuilder(
          animation: bounceEase,
          builder: (_, child) => Positioned(
            top: 130 + bounceEase.value * 18,
            left: -8,
            child: Opacity(opacity: 0.88, child: child),
          ),
          child: CustomPaint(
            painter: _StarKidPainter(),
            size: const Size(62, 62),
          ),
        ),

        // ── Cloud (top-left, drifts side-to-side) ─────────────────
        AnimatedBuilder(
          animation: floatEase,
          builder: (_, child) => Positioned(
            top: 60 + floatEase.value * 10,
            left: 10 + floatEase.value * 12,
            child: Opacity(opacity: 0.80, child: child),
          ),
          child: CustomPaint(
            painter: _CloudPainter(),
            size: const Size(76, 50),
          ),
        ),

        // ── Bee (right edge, wiggles up/down + tilts) ─────────────
        // AnimatedBuilder(
        //   animation: wiggleEase,
        //   builder: (_, child) => Positioned(
        //     top: 195 + wiggleEase.value * 22,
        //     right: -6,
        //     child: Opacity(
        //       opacity: 0.88,
        //       child: Transform.rotate(
        //         angle: (wiggleEase.value - 0.5) * 0.28,
        //         child: child,
        //       ),
        //     ),
        //   ),
        //   child: CustomPaint(
        //     painter: _BeePainter(),
        //     size: const Size(52, 64),
        //   ),
        // ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sun
// ─────────────────────────────────────────────────────────────────────────────
class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.30;

    // Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFCC02)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a  = i * pi / 4 - pi / 8;
      final r1 = r + 5;
      final r2 = r + 16;
      canvas.drawLine(
        Offset(cx + cos(a) * r1, cy + sin(a) * r1),
        Offset(cx + cos(a) * r2, cy + sin(a) * r2),
        rayPaint,
      );
    }

    // Body
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xFFFFD600));
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()
          ..color = const Color(0xFFFFAA00)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawCircle(Offset(cx - r * 0.30, cy - r * 0.12), r * 0.13, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.30, cy - r * 0.12), r * 0.13, eyePaint);
    // Eye shine
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.17), r * 0.05, shinePaint);
    canvas.drawCircle(Offset(cx + r * 0.35, cy - r * 0.17), r * 0.05, shinePaint);

    // Smile
    final smilePath = Path()
      ..moveTo(cx - r * 0.28, cy + r * 0.18)
      ..quadraticBezierTo(cx, cy + r * 0.42, cx + r * 0.28, cy + r * 0.18);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF3D2B1F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Cheeks
    canvas.drawCircle(Offset(cx - r * 0.50, cy + r * 0.12), r * 0.13,
        Paint()..color = const Color(0xFFFF9EA0).withValues(alpha: 0.55));
    canvas.drawCircle(Offset(cx + r * 0.50, cy + r * 0.12), r * 0.13,
        Paint()..color = const Color(0xFFFF9EA0).withValues(alpha: 0.55));
  }

  @override
  bool shouldRepaint(_SunPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Star kid
// ─────────────────────────────────────────────────────────────────────────────
class _StarKidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.45;

    // Draw 5-pointed star
    final starPath = Path();
    for (var i = 0; i < 5; i++) {
      final outer = Offset(
        cx + cos(i * 2 * pi / 5 - pi / 2) * r,
        cy + sin(i * 2 * pi / 5 - pi / 2) * r,
      );
      final inner = Offset(
        cx + cos((i * 2 * pi / 5 + pi / 5) - pi / 2) * r * 0.42,
        cy + sin((i * 2 * pi / 5 + pi / 5) - pi / 2) * r * 0.42,
      );
      if (i == 0) {
        starPath.moveTo(outer.dx, outer.dy);
      } else {
        starPath.lineTo(outer.dx, outer.dy);
      }
      starPath.lineTo(inner.dx, inner.dy);
    }
    starPath.close();

    canvas.drawPath(starPath,
        Paint()..color = const Color(0xFFFFD600));
    canvas.drawPath(
      starPath,
      Paint()
        ..color = const Color(0xFFFFAA00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Eyes (sit slightly above center)
    final eyePaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawCircle(Offset(cx - r * 0.22, cy - r * 0.05), r * 0.10, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.22, cy - r * 0.05), r * 0.10, eyePaint);
    // Shine
    canvas.drawCircle(Offset(cx - r * 0.17, cy - r * 0.09), r * 0.04,
        Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx + r * 0.27, cy - r * 0.09), r * 0.04,
        Paint()..color = Colors.white);

    // Smile
    final smilePath = Path()
      ..moveTo(cx - r * 0.20, cy + r * 0.10)
      ..quadraticBezierTo(cx, cy + r * 0.30, cx + r * 0.20, cy + r * 0.10);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF3D2B1F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    // Rosy cheeks
    canvas.drawCircle(Offset(cx - r * 0.38, cy + r * 0.06), r * 0.10,
        Paint()..color = const Color(0xFFFF9EA0).withValues(alpha: 0.50));
    canvas.drawCircle(Offset(cx + r * 0.38, cy + r * 0.06), r * 0.10,
        Paint()..color = const Color(0xFFFF9EA0).withValues(alpha: 0.50));
  }

  @override
  bool shouldRepaint(_StarKidPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Cloud
// ─────────────────────────────────────────────────────────────────────────────
class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final cloudPaint = Paint()..color = Colors.white;
    final outlinePaint = Paint()
      ..color = const Color(0xFFCCE5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Cloud blobs
    final blobs = [
      (cx: w * 0.50, cy: h * 0.52, r: h * 0.38),
      (cx: w * 0.28, cy: h * 0.60, r: h * 0.28),
      (cx: w * 0.72, cy: h * 0.62, r: h * 0.26),
      (cx: w * 0.38, cy: h * 0.42, r: h * 0.30),
      (cx: w * 0.63, cy: h * 0.44, r: h * 0.26),
    ];

    for (final b in blobs) {
      canvas.drawCircle(Offset(b.cx, b.cy), b.r, cloudPaint);
    }
    for (final b in blobs) {
      canvas.drawCircle(Offset(b.cx, b.cy), b.r, outlinePaint);
    }

    // Face (centered)
    final fcx = w * 0.50;
    final fcy = h * 0.58;
    final eyePaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawCircle(Offset(fcx - w * 0.10, fcy - h * 0.05), h * 0.07, eyePaint);
    canvas.drawCircle(Offset(fcx + w * 0.10, fcy - h * 0.05), h * 0.07, eyePaint);

    final smilePath = Path()
      ..moveTo(fcx - w * 0.10, fcy + h * 0.06)
      ..quadraticBezierTo(fcx, fcy + h * 0.18, fcx + w * 0.10, fcy + h * 0.06);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF3D2B1F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CloudPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Bee
// ─────────────────────────────────────────────────────────────────────────────
class _BeePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final bw = size.width * 0.38;
    final bh = size.height * 0.30;

    // Wings
    final wingPaint = Paint()..color = const Color(0xFFB3E5FC).withValues(alpha: 0.75);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - bw * 0.6, cy - bh * 1.0), width: bw * 1.2, height: bh * 1.0),
      wingPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + bw * 0.6, cy - bh * 1.0), width: bw * 1.2, height: bh * 1.0),
      wingPaint,
    );
    // Wing outline
    final wingOutline = Paint()
      ..color = const Color(0xFF81D4FA).withValues(alpha: 0.60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - bw * 0.6, cy - bh * 1.0), width: bw * 1.2, height: bh * 1.0),
      wingOutline,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + bw * 0.6, cy - bh * 1.0), width: bw * 1.2, height: bh * 1.0),
      wingOutline,
    );

    // Body
    final bodyRect = Rect.fromCenter(center: Offset(cx, cy + bh * 0.2), width: bw * 2, height: bh * 2.2);
    canvas.drawOval(bodyRect, Paint()..color = const Color(0xFFFFD600));
    // Stripes
    final stripePaint = Paint()..color = const Color(0xFF3D2B1F);
    for (var i = 0; i < 3; i++) {
      final y = cy + bh * 0.2 - bh * 0.7 + i * bh * 0.55;
      canvas.save();
      canvas.clipRect(bodyRect.inflate(1));
      canvas.drawRect(
        Rect.fromLTWH(cx - bw, y, bw * 2, bh * 0.25),
        stripePaint,
      );
      canvas.restore();
    }
    // Body outline
    canvas.drawOval(
      bodyRect,
      Paint()
        ..color = const Color(0xFFFFAA00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Head
    final headR = bw * 0.65;
    canvas.drawCircle(
      Offset(cx, cy - bh * 0.88),
      headR,
      Paint()..color = const Color(0xFFFFD600),
    );
    canvas.drawCircle(
      Offset(cx, cy - bh * 0.88),
      headR,
      Paint()
        ..color = const Color(0xFFFFAA00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Eyes
    final ey = cy - bh * 0.88;
    final eyePaint = Paint()..color = const Color(0xFF3D2B1F);
    canvas.drawCircle(Offset(cx - headR * 0.35, ey - headR * 0.10), headR * 0.18, eyePaint);
    canvas.drawCircle(Offset(cx + headR * 0.35, ey - headR * 0.10), headR * 0.18, eyePaint);
    canvas.drawCircle(Offset(cx - headR * 0.28, ey - headR * 0.16), headR * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx + headR * 0.42, ey - headR * 0.16), headR * 0.07, Paint()..color = Colors.white);

    // Smile
    final smilePath = Path()
      ..moveTo(cx - headR * 0.30, ey + headR * 0.15)
      ..quadraticBezierTo(cx, ey + headR * 0.42, cx + headR * 0.30, ey + headR * 0.15);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF3D2B1F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    // Antennae
    final antPaint = Paint()
      ..color = const Color(0xFF3D2B1F)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - headR * 0.28, ey - headR * 0.85),
        Offset(cx - headR * 0.55, ey - headR * 1.55), antPaint);
    canvas.drawLine(Offset(cx + headR * 0.28, ey - headR * 0.85),
        Offset(cx + headR * 0.55, ey - headR * 1.55), antPaint);
    // Antenna tips
    canvas.drawCircle(Offset(cx - headR * 0.55, ey - headR * 1.55), headR * 0.12,
        Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawCircle(Offset(cx + headR * 0.55, ey - headR * 1.55), headR * 0.12,
        Paint()..color = const Color(0xFFFF6B6B));
  }

  @override
  bool shouldRepaint(_BeePainter _) => false;
}
