import 'dart:math';
import 'package:flutter/material.dart';

class ReadingActivityScreen extends StatefulWidget {
  const ReadingActivityScreen({super.key});

  @override
  State<ReadingActivityScreen> createState() => _ReadingActivityScreenState();
}

class _ReadingActivityScreenState extends State<ReadingActivityScreen> {
  static const _color = Color(0xFFFF6B6B);

  static const _stories = [
    _Story(
      title: 'The Little Sun',
      emoji: '☀️',
      text:
          'The little sun woke up early. It stretched its golden rays across the sky. '
          'Birds began to sing. Flowers opened their petals. '
          'The whole world smiled at the warm, bright sun.',
      questions: [
        _Quiz(
          question: 'What did the sun do early?',
          choices: ['Slept in bed', 'Woke up early', 'Played in the rain', 'Hid in a cloud'],
          answer: 'Woke up early',
        ),
        _Quiz(
          question: 'What happened to the flowers?',
          choices: ['They wilted', 'They flew away', 'They opened petals', 'They turned blue'],
          answer: 'They opened petals',
        ),
        _Quiz(
          question: 'How did the world feel?',
          choices: ['Sad', 'Cold', 'Scared', 'Happy'],
          answer: 'Happy',
        ),
      ],
    ),
    _Story(
      title: 'The Blue Fish',
      emoji: '🐟',
      text:
          'A small blue fish lived in a big ocean. Every day it swam past coral reefs '
          'and colourful seaweed. One day it found a shiny treasure chest on the sand. '
          'Inside was a golden key and a friendly crab.',
      questions: [
        _Quiz(
          question: 'Where did the fish live?',
          choices: ['A river', 'A pond', 'A big ocean', 'A fish tank'],
          answer: 'A big ocean',
        ),
        _Quiz(
          question: 'What did the fish find?',
          choices: ['A pearl', 'A treasure chest', 'A shipwreck', 'A jellyfish'],
          answer: 'A treasure chest',
        ),
        _Quiz(
          question: 'What was inside the chest?',
          choices: [
            'Gold coins and a map',
            'A golden key and a crab',
            'Pearls and a starfish',
            'Silver rings and a fish',
          ],
          answer: 'A golden key and a crab',
        ),
      ],
    ),
    _Story(
      title: 'The Magic Tree',
      emoji: '🌳',
      text:
          'Deep in the forest stood a magic tree. Its leaves glowed green at night. '
          'Animals came from far away to rest under its shade. '
          'A wise old owl sat on the tallest branch and told stories to everyone below.',
      questions: [
        _Quiz(
          question: 'Where was the magic tree?',
          choices: ['In a city', 'In the sea', 'In the forest', 'On a mountain'],
          answer: 'In the forest',
        ),
        _Quiz(
          question: 'What colour did the leaves glow?',
          choices: ['Blue', 'Red', 'Yellow', 'Green'],
          answer: 'Green',
        ),
        _Quiz(
          question: 'What did the owl do?',
          choices: ['Sang songs', 'Told stories', 'Flew away', 'Ate berries'],
          answer: 'Told stories',
        ),
      ],
    ),
  ];

  late _Story _story;
  int _phase = 0; // 0 = reading, 1 = quiz
  int _quizIndex = 0;
  int _score = 0;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _story = _stories[Random().nextInt(_stories.length)];
  }

  void _onAnswerTap(String choice) {
    if (_selected != null) return;
    setState(() {
      _selected = choice;
      if (choice == _story.questions[_quizIndex].answer) _score++;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (_quizIndex < _story.questions.length - 1) {
        setState(() {
          _quizIndex++;
          _selected = null;
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final total = _story.questions.length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _score == total ? '🏆' : _score >= total ~/ 2 ? '😊' : '💪',
                style: const TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 12),
              Text(
                _score == total
                    ? 'Perfect Reader!'
                    : _score >= total ~/ 2
                        ? 'Well Done!'
                        : 'Keep Reading!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_score / $total questions correct',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Exit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _story = _stories[Random().nextInt(_stories.length)];
                          _phase = 0;
                          _quizIndex = 0;
                          _score = 0;
                          _selected = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Read Again',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              color: _color,
              title: _story.title,
              emoji: _story.emoji,
              phase: _phase,
              quizIndex: _quizIndex,
              total: _story.questions.length,
              score: _score,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.06, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _phase == 0
                    ? _ReadingPane(
                        key: const ValueKey('read'),
                        story: _story,
                        color: _color,
                        onDone: () => setState(() => _phase = 1),
                      )
                    : _QuizPane(
                        key: ValueKey('quiz$_quizIndex'),
                        quiz: _story.questions[_quizIndex],
                        quizIndex: _quizIndex,
                        total: _story.questions.length,
                        selected: _selected,
                        color: _color,
                        onAnswer: _onAnswerTap,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.color,
    required this.title,
    required this.emoji,
    required this.phase,
    required this.quizIndex,
    required this.total,
    required this.score,
    required this.onBack,
  });

  final Color color;
  final String title, emoji;
  final int phase, quizIndex, total, score;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xFF2D3142),
              ),
              const Spacer(),
              if (phase == 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⭐ $score pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          if (phase == 1) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${quizIndex + 1} of $total',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '${(((quizIndex + 1) / total) * 100).round()}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (quizIndex + 1) / total,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Reading pane ─────────────────────────────────────────────────────────────

class _ReadingPane extends StatelessWidget {
  const _ReadingPane({
    super.key,
    required this.story,
    required this.color,
    required this.onDone,
  });

  final _Story story;
  final Color color;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Story card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Big emoji + title
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            story.emoji,
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Text(
                        story.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      story.text,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF4A4E69),
                        height: 1.8,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onDone,
              icon: const Icon(Icons.quiz_rounded),
              label: const Text(
                'Answer Questions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                shadowColor: color.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quiz pane ────────────────────────────────────────────────────────────────

class _QuizPane extends StatelessWidget {
  const _QuizPane({
    super.key,
    required this.quiz,
    required this.quizIndex,
    required this.total,
    required this.selected,
    required this.color,
    required this.onAnswer,
  });

  final _Quiz quiz;
  final int quizIndex, total;
  final String? selected;
  final Color color;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              quiz.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Answer choices
          Expanded(
            child: ListView.separated(
              itemCount: quiz.choices.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final choice = quiz.choices[i];
                final isSelected = selected == choice;
                final answered = selected != null;
                final isCorrect = choice == quiz.answer;

                Color bg = Colors.white;
                Color border = Colors.grey.shade200;
                Color textColor = const Color(0xFF2D3142);
                IconData? icon;

                if (answered) {
                  if (isCorrect) {
                    bg = const Color(0xFF06D6A0);
                    border = const Color(0xFF06D6A0);
                    textColor = Colors.white;
                    icon = Icons.check_circle_rounded;
                  } else if (isSelected) {
                    bg = const Color(0xFFFF6B6B);
                    border = const Color(0xFFFF6B6B);
                    textColor = Colors.white;
                    icon = Icons.cancel_rounded;
                  }
                }

                return GestureDetector(
                  onTap: () => onAnswer(choice),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            choice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (icon != null) Icon(icon, color: Colors.white, size: 22),
                      ],
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

// ── Data models ──────────────────────────────────────────────────────────────

class _Story {
  const _Story({
    required this.title,
    required this.emoji,
    required this.text,
    required this.questions,
  });

  final String title, emoji, text;
  final List<_Quiz> questions;
}

class _Quiz {
  const _Quiz({
    required this.question,
    required this.choices,
    required this.answer,
  });

  final String question;
  final List<String> choices;
  final String answer;
}
