import 'package:flutter/material.dart';

class ActivityPerformanceCard extends StatelessWidget {
  const ActivityPerformanceCard({super.key});

  static const _activities = [
    _ActivityStat(
      name: 'Numbers',
      emoji: '🔢',
      color: Color(0xFFFF8C42),
      score: 0.80,
      sessions: 6,
      avgTime: '11 min',
      trend: '+12%',
      positive: true,
    ),
    _ActivityStat(
      name: 'Reading',
      emoji: '📖',
      color: Color(0xFFFF6B6B),
      score: 0.93,
      sessions: 5,
      avgTime: '14 min',
      trend: '+8%',
      positive: true,
    ),
    _ActivityStat(
      name: 'Puzzles',
      emoji: '🧩',
      color: Color(0xFF7C83FD),
      score: 0.60,
      sessions: 4,
      avgTime: '9 min',
      trend: '-5%',
      positive: false,
    ),
    _ActivityStat(
      name: 'Drawing',
      emoji: '🎨',
      color: Color(0xFF06D6A0),
      score: 1.0,
      sessions: 7,
      avgTime: '18 min',
      trend: '+20%',
      positive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: _activities.map((a) => _ActivityRow(stat: a)).toList(),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.stat});
  final _ActivityStat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(stat.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  stat.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: stat.positive
                      ? const Color(0xFF06D6A0).withValues(alpha: 0.12)
                      : const Color(0xFFFF6B6B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  stat.trend,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: stat.positive
                        ? const Color(0xFF06D6A0)
                        : const Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: stat.score,
              minHeight: 7,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(stat.color),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _Mini(label: '${(stat.score * 100).round()}% score'),
              const SizedBox(width: 14),
              _Mini(label: '${stat.sessions} sessions'),
              const SizedBox(width: 14),
              _Mini(label: '⏱ ${stat.avgTime} avg'),
            ],
          ),
          Divider(height: 0, thickness: 1, color: Colors.grey.shade100),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
    );
  }
}

class _ActivityStat {
  const _ActivityStat({
    required this.name,
    required this.emoji,
    required this.color,
    required this.score,
    required this.sessions,
    required this.avgTime,
    required this.trend,
    required this.positive,
  });

  final String name, emoji, avgTime, trend;
  final Color color;
  final double score;
  final int sessions;
  final bool positive;
}
