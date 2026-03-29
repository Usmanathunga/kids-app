import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/cartoon_characters.dart';
import 'numbers_activity_screen.dart';
import 'drawing_activity_screen.dart';
import 'puzzle_activity_screen.dart';
import 'reading_activity_screen.dart';
import 'widgets/activity_card.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({super.key});

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _activities = [
    (title: 'Numbers', icon: Icons.looks_one_rounded, color: Color(0xFFFF8C42)),
    (title: 'Reading', icon: Icons.menu_book_rounded, color: Color(0xFFFF6B6B)),
    (title: 'Puzzles', icon: Icons.extension_rounded, color: Color(0xFF7C83FD)),
    (title: 'Drawing', icon: Icons.brush_rounded, color: Color(0xFF06D6A0)),
  ];

  // One set of floating particles per activity zone
  static final _particles = _buildParticles();

  static List<_Particle> _buildParticles() {
    final rng = Random(42);
    final configs = [
      (color: const Color(0xFFFF8C42), glyphs: ['1', '2', '3', '＋', '＝']),
      (color: const Color(0xFFFF6B6B), glyphs: ['📖', 'A', 'B', 'C', '✏️']),
      (color: const Color(0xFF7C83FD), glyphs: ['🧩', '◆', '▲', '●', '★']),
      (color: const Color(0xFF06D6A0), glyphs: ['🎨', '●', '♥', '✦', '🖌️']),
    ];
    final list = <_Particle>[];
    for (final c in configs) {
      for (var i = 0; i < 7; i++) {
        list.add(_Particle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          size: 12 + rng.nextDouble() * 14,
          speed: 0.008 + rng.nextDouble() * 0.012,
          phase: rng.nextDouble() * 2 * pi,
          amplitude: 0.03 + rng.nextDouble() * 0.04,
          glyph: c.glyphs[rng.nextInt(c.glyphs.length)],
          color: c.color,
        ));
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigate(BuildContext ctx, String title) {
    final routes = {
      'Numbers': () => const NumbersActivityScreen(),
      'Reading': () => const ReadingActivityScreen(),
      'Puzzles': () => const PuzzleActivityScreen(),
      'Drawing': () => const DrawingActivityScreen(),
    };
    final builder = routes[title];
    if (builder != null) {
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => builder()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) => CustomPaint(
            painter: _ParticlePainter(_particles, _ctrl.value),
            child: const SizedBox.expand(),
          ),
        ),
        // Cartoon characters
        const CartoonCharacters(),
        // Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'For ages 5-9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'What do you\nwant to do?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3142),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  for (final a in _activities)
                    ActivityCard(
                      title: a.title,
                      icon: a.icon,
                      color: a.color,
                      onTap: () => _navigate(context, a.title),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Particle model ────────────────────────────────────────────────────────────

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.amplitude,
    required this.glyph,
    required this.color,
  });

  final double x, y, size, speed, phase, amplitude;
  final String glyph;
  final Color color;
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles, this.t);

  final List<_Particle> particles;
  final double t; // 0..1 from AnimationController

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Float upward, wrap around, sway side-to-side
      final progress = (p.y - t * p.speed * 60) % 1.0;
      final dy = (1 - progress) * size.height;
      final dx = p.x * size.width +
          sin(t * 2 * pi * 2 + p.phase) * p.amplitude * size.width;

      final opacity = progress < 0.15
          ? progress / 0.15
          : progress > 0.85
              ? (1 - progress) / 0.15
              : 1.0;

      final painter = TextPainter(
        text: TextSpan(
          text: p.glyph,
          style: TextStyle(
            fontSize: p.size,
            color: p.color.withValues(alpha: opacity * 0.30),
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        Offset(dx - painter.width / 2, dy - painter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
