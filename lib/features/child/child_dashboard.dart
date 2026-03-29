import 'package:flutter/material.dart';
import 'numbers_activity_screen.dart';
import 'drawing_activity_screen.dart';
import 'puzzle_activity_screen.dart';
import 'reading_activity_screen.dart';
import 'widgets/activity_card.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  static const _activities = [
    (title: 'Numbers', icon: Icons.looks_one_rounded, color: Color(0xFFFF8C42)),
    (title: 'Reading', icon: Icons.menu_book_rounded, color: Color(0xFFFF6B6B)),
    (title: 'Puzzles', icon: Icons.extension_rounded, color: Color(0xFF7C83FD)),
    (title: 'Drawing', icon: Icons.brush_rounded, color: Color(0xFF06D6A0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                  onTap: a.title == 'Numbers'
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NumbersActivityScreen(),
                            ),
                          )
                      : a.title == 'Reading'
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ReadingActivityScreen(),
                                ),
                              )
                          : a.title == 'Puzzles'
                              ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PuzzleActivityScreen(),
                                    ),
                                  )
                              : a.title == 'Drawing'
                                  ? () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const DrawingActivityScreen(),
                                        ),
                                      )
                                  : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
