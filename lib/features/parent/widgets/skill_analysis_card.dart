import 'package:flutter/material.dart';

class SkillAnalysisCard extends StatelessWidget {
  const SkillAnalysisCard({super.key});

  static const _skills = [
    _Skill(name: 'Numeracy',      icon: Icons.calculate_rounded,     value: 0.78, color: Color(0xFFFF8C42)),
    _Skill(name: 'Literacy',      icon: Icons.menu_book_rounded,      value: 0.92, color: Color(0xFFFF6B6B)),
    _Skill(name: 'Logic',         icon: Icons.psychology_rounded,     value: 0.60, color: Color(0xFF7C83FD)),
    _Skill(name: 'Creativity',    icon: Icons.brush_rounded,          value: 0.95, color: Color(0xFF06D6A0)),
    _Skill(name: 'Attention',     icon: Icons.center_focus_strong_rounded, value: 0.72, color: Color(0xFF4ECDC4)),
    _Skill(name: 'Perseverance',  icon: Icons.trending_up_rounded,   value: 0.68, color: Color(0xFFFF6B9D)),
  ];

  String _level(double v) {
    if (v >= 0.90) return 'Excellent';
    if (v >= 0.75) return 'Good';
    if (v >= 0.55) return 'Developing';
    return 'Needs Focus';
  }

  @override
  Widget build(BuildContext context) {
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
        children: _skills.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: s.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(s.icon, size: 18, color: s.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2D3142))),
                        Text(
                          _level(s.value),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s.color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: s.value,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(s.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(s.value * 100).round()}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _Skill {
  const _Skill({
    required this.name,
    required this.icon,
    required this.value,
    required this.color,
  });

  final String name;
  final IconData icon;
  final double value;
  final Color color;
}
