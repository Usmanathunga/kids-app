import 'package:flutter/material.dart';
import 'widgets/activity_performance_card.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/skill_analysis_card.dart';
import 'widgets/suggestions_card.dart';
import 'widgets/recent_activity_tile.dart';
import 'widgets/stat_chip.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          _Header(),
          const SizedBox(height: 20),

          // ── Today's stats ────────────────────────────────────────
          _sectionLabel('Today\'s Overview'),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(child: StatChip(label: 'Screen Time', value: '2h 15m', icon: Icons.timer_rounded, color: Color(0xFF7C83FD))),
              SizedBox(width: 10),
              Expanded(child: StatChip(label: 'Activities', value: '4 Done', icon: Icons.check_circle_rounded, color: Color(0xFF06D6A0))),
              SizedBox(width: 10),
              Expanded(child: StatChip(label: 'Streak', value: '🔥 5 days', icon: Icons.local_fire_department_rounded, color: Color(0xFFFF8C42))),
            ],
          ),
          const SizedBox(height: 24),

          // ── Activity performance ─────────────────────────────────
          _sectionLabel('Activity Performance'),
          const SizedBox(height: 12),
          const ActivityPerformanceCard(),
          const SizedBox(height: 24),

          // ── Weekly chart ─────────────────────────────────────────
          _sectionLabel('Weekly Activity (mins)'),
          const SizedBox(height: 12),
          const WeeklyChart(),
          const SizedBox(height: 24),

          // ── Skill analysis ───────────────────────────────────────
          _sectionLabel('Skill Analysis'),
          const SizedBox(height: 12),
          const SkillAnalysisCard(),
          const SizedBox(height: 24),

          // ── Smart suggestions ────────────────────────────────────
          _sectionLabel('Smart Suggestions'),
          const SizedBox(height: 12),
          const SuggestionsCard(),
          const SizedBox(height: 24),

          // ── Recent activities ────────────────────────────────────
          _sectionLabel('Recent Activities'),
          const SizedBox(height: 12),
          const RecentActivityTile(
            title: 'Numbers Quiz',
            subtitle: 'Score: 4/5 · 12 mins ago',
            icon: Icons.looks_one_rounded,
            color: Color(0xFFFF8C42),
            score: 0.80,
          ),
          const RecentActivityTile(
            title: 'Reading — The Blue Fish',
            subtitle: 'Score: 3/3 · 30 mins ago',
            icon: Icons.menu_book_rounded,
            color: Color(0xFFFF6B6B),
            score: 1.0,
          ),
          const RecentActivityTile(
            title: 'Memory Puzzle',
            subtitle: 'Solved in 14 moves · 1h ago',
            icon: Icons.extension_rounded,
            color: Color(0xFF7C83FD),
            score: 0.65,
          ),
          const RecentActivityTile(
            title: 'Drawing Canvas',
            subtitle: '18 mins spent · Today',
            icon: Icons.brush_rounded,
            color: Color(0xFF06D6A0),
            score: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3142),
          letterSpacing: 0.1,
        ),
      );
}

// ── Header widget ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C83FD), Color(0xFF4ECDC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C83FD).withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('👦', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Parent! 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your child is doing great today!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Sunday',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
