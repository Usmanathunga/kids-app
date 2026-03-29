import 'package:flutter/material.dart';

class SuggestionsCard extends StatelessWidget {
  const SuggestionsCard({super.key});

  static const _suggestions = [
    _Suggestion(
      emoji: '🧩',
      title: 'Boost Logic Skills',
      body: 'Your child\'s puzzle score is at 60%. Try 10 min of puzzle play daily to strengthen logical thinking.',
      color: Color(0xFF7C83FD),
      tag: 'Focus Area',
    ),
    _Suggestion(
      emoji: '📖',
      title: 'Reading is Thriving!',
      body: 'Excellent literacy progress (92%). Introduce slightly harder stories to keep the challenge growing.',
      color: Color(0xFFFF6B6B),
      tag: 'Keep Going',
    ),
    _Suggestion(
      emoji: '⏰',
      title: 'Balance Screen Time',
      body: 'Drawing sessions average 18 min — the longest. Consider rotating activities more evenly.',
      color: Color(0xFF4ECDC4),
      tag: 'Tip',
    ),
    _Suggestion(
      emoji: '🔢',
      title: 'Number Practice',
      body: 'Score improved by 12% this week! Multiplication questions are the next step — try the Numbers quiz daily.',
      color: Color(0xFFFF8C42),
      tag: 'Progress',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _suggestions
          .map((s) => _SuggestionTile(suggestion: s))
          .toList(),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion});
  final _Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: suggestion.color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: suggestion.color.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(suggestion.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        suggestion.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: suggestion.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        suggestion.tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: suggestion.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  suggestion.body,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestion {
  const _Suggestion({
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
    required this.tag,
  });

  final String emoji, title, body, tag;
  final Color color;
}
