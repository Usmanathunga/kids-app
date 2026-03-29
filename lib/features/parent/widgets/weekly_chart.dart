import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  // Minutes per day per activity [Mon..Sun]
  static const _data = [
    _Bar(day: 'Mon', numbers: 10, reading: 15, puzzles: 8,  drawing: 20),
    _Bar(day: 'Tue', numbers: 12, reading: 10, puzzles: 14, drawing: 10),
    _Bar(day: 'Wed', numbers: 8,  reading: 18, puzzles: 6,  drawing: 25),
    _Bar(day: 'Thu', numbers: 15, reading: 12, puzzles: 10, drawing: 18),
    _Bar(day: 'Fri', numbers: 20, reading: 14, puzzles: 12, drawing: 15),
    _Bar(day: 'Sat', numbers: 18, reading: 20, puzzles: 18, drawing: 30),
    _Bar(day: 'Sun', numbers: 11, reading: 9,  puzzles: 9,  drawing: 18),
  ];

  static const _colors = [
    Color(0xFFFF8C42), // Numbers
    Color(0xFFFF6B6B), // Reading
    Color(0xFF7C83FD), // Puzzles
    Color(0xFF06D6A0), // Drawing
  ];
  static const _labels = ['Numbers', 'Reading', 'Puzzles', 'Drawing'];

  @override
  Widget build(BuildContext context) {
    final maxTotal = _data
        .map((b) => b.numbers + b.reading + b.puzzles + b.drawing)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: List.generate(
              _labels.length,
              (i) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: _colors[i], shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(_labels[i], style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Bars
          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _data.map((b) {
                final segments = [b.numbers, b.reading, b.puzzles, b.drawing];
                final total = segments.reduce((a, c) => a + c).toDouble();
                final heightFraction = total / maxTotal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 110 * heightFraction,
                          child: Column(
                            children: List.generate(segments.length, (i) {
                              final frac = segments[i] / total;
                              return Flexible(
                                flex: (frac * 100).round(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colors[i],
                                    borderRadius: i == 0
                                        ? const BorderRadius.vertical(top: Radius.circular(6))
                                        : BorderRadius.zero,
                                  ),
                                ),
                              );
                            }).reversed.toList(),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(b.day, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar {
  const _Bar({
    required this.day,
    required this.numbers,
    required this.reading,
    required this.puzzles,
    required this.drawing,
  });

  final String day;
  final int numbers, reading, puzzles, drawing;
}
