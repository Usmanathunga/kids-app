import 'dart:math';
import 'package:flutter/material.dart';

class NumbersActivityScreen extends StatefulWidget {
  const NumbersActivityScreen({super.key});

  @override
  State<NumbersActivityScreen> createState() => _NumbersActivityScreenState();
}

class _NumbersActivityScreenState extends State<NumbersActivityScreen>
    with SingleTickerProviderStateMixin {
  static const _color = Color(0xFFFF8C42);

  late _Question _question;
  int _score = 0;
  int _round = 1;
  static const _totalRounds = 5;

  int? _selected;
  bool _answered = false;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnim = Tween<double>(begin: 1, end: 1.18).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut),
    );
    _nextQuestion();
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    setState(() {
      _question = _Question.generate();
      _selected = null;
      _answered = false;
    });
    _bounceCtrl.forward(from: 0);
  }

  void _onAnswer(int choice) {
    if (_answered) return;
    final correct = choice == _question.answer;
    setState(() {
      _selected = choice;
      _answered = true;
      if (correct) _score++;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (_round < _totalRounds) {
        setState(() => _round++);
        _nextQuestion();
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
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
                _score >= 4 ? '🎉' : _score >= 2 ? '😊' : '💪',
                style: const TextStyle(fontSize: 56),
              ),
              const SizedBox(height: 12),
              Text(
                _score >= 4 ? 'Amazing!' : _score >= 2 ? 'Good job!' : 'Keep trying!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You got $_score / $_totalRounds correct',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
                          _score = 0;
                          _round = 1;
                        });
                        _nextQuestion();
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
                        'Play Again',
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
              round: _round,
              total: _totalRounds,
              score: _score,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _QuestionCard(
                      question: _question,
                      bounceAnim: _bounceAnim,
                      color: _color,
                    ),
                    const SizedBox(height: 36),
                    _AnswerGrid(
                      question: _question,
                      selected: _selected,
                      answered: _answered,
                      onAnswer: _onAnswer,
                      color: _color,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.color,
    required this.round,
    required this.total,
    required this.score,
    required this.onBack,
  });

  final Color color;
  final int round, total, score;
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question $round of $total',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${((round / total) * 100).round()}%',
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
                    value: round / total,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── Question card ────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.bounceAnim,
    required this.color,
  });

  final _Question question;
  final Animation<double> bounceAnim;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
      child: Column(
        children: [
          ScaleTransition(
            scale: bounceAnim,
            child: Text(
              question.emoji,
              style: const TextStyle(fontSize: 52),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Answer grid ──────────────────────────────────────────────────────────────

class _AnswerGrid extends StatelessWidget {
  const _AnswerGrid({
    required this.question,
    required this.selected,
    required this.answered,
    required this.onAnswer,
    required this.color,
  });

  final _Question question;
  final int? selected;
  final bool answered;
  final ValueChanged<int> onAnswer;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2.2,
      children: question.choices.map((c) {
        Color bg = Colors.white;
        Color border = Colors.grey.shade200;
        Color textColor = const Color(0xFF2D3142);
        IconData? trailingIcon;

        if (answered) {
          if (c == question.answer) {
            bg = const Color(0xFF06D6A0);
            border = const Color(0xFF06D6A0);
            textColor = Colors.white;
            trailingIcon = Icons.check_circle_rounded;
          } else if (c == selected) {
            bg = const Color(0xFFFF6B6B);
            border = const Color(0xFFFF6B6B);
            textColor = Colors.white;
            trailingIcon = Icons.cancel_rounded;
          }
        }

        return GestureDetector(
          onTap: () => onAnswer(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$c',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, color: Colors.white, size: 20),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Question model ───────────────────────────────────────────────────────────

class _Question {
  const _Question({
    required this.prompt,
    required this.emoji,
    required this.answer,
    required this.choices,
  });

  final String prompt;
  final String emoji;
  final int answer;
  final List<int> choices;

  static const _emojis = ['🍎', '🌟', '🐶', '🎈', '🍕', '🦋', '🏆', '🎵'];

  factory _Question.generate() {
    final rng = Random();
    final type = rng.nextInt(5);
    final emoji = _emojis[rng.nextInt(_emojis.length)];

    late int answer;
    late String prompt;

    switch (type) {
      case 0: // count
        answer = rng.nextInt(9) + 1;
        prompt = 'How many ${emoji}s are there?\n'
            '${emoji * answer}';
        break;
      case 1: // addition
        final a = rng.nextInt(9) + 1;
        final b = rng.nextInt(9) + 1;
        answer = a + b;
        prompt = 'What is $a + $b?';
        break;
      case 2: // subtraction
        final a = rng.nextInt(8) + 2;
        final b = rng.nextInt(a - 1) + 1;
        answer = a - b;
        prompt = 'What is $a − $b?';
        break;
      case 3: // next number
        final a = rng.nextInt(18) + 1;
        answer = a + 1;
        prompt = 'Which number comes after $a?';
        break;
      default: // multiplication
        final a = rng.nextInt(5) + 1;
        final b = rng.nextInt(5) + 1;
        answer = a * b;
        prompt = 'What is $a × $b?';
    }

    // Generate 3 wrong choices close to answer
    final wrongs = <int>{};
    while (wrongs.length < 3) {
      final offset = rng.nextInt(5) + 1;
      final wrong = rng.nextBool() ? answer + offset : answer - offset;
      if (wrong != answer && wrong >= 0) wrongs.add(wrong);
    }

    final choices = [answer, ...wrongs]..shuffle();
    return _Question(
      prompt: prompt,
      emoji: emoji,
      answer: answer,
      choices: choices,
    );
  }
}
