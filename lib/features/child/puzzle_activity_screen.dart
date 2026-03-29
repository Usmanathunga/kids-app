import 'dart:async';
import 'package:flutter/material.dart';

class PuzzleActivityScreen extends StatefulWidget {
  const PuzzleActivityScreen({super.key});

  @override
  State<PuzzleActivityScreen> createState() => _PuzzleActivityScreenState();
}

class _PuzzleActivityScreenState extends State<PuzzleActivityScreen> {
  static const _color = Color(0xFF7C83FD);

  static const _allEmojis = [
    '🐶', '🐱', '🦊', '🐸', '🦁', '🐧',
    '🦋', '🐙', '🌈', '⭐', '🍕', '🎈',
  ];

  late List<_Tile> _tiles;
  int? _firstFlipped;
  bool _checking = false;
  int _moves = 0;
  int _matches = 0;
  int _seconds = 0;
  late Timer _timer;

  int get _totalPairs => _tiles.length ~/ 2;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    final emojis = List.of(_allEmojis)..shuffle();
    final picked = emojis.take(6).toList();
    final pairs = [...picked, ...picked]..shuffle();
    _tiles = List.generate(pairs.length, (i) => _Tile(emoji: pairs[i]));
    _firstFlipped = null;
    _checking = false;
    _moves = 0;
    _matches = 0;
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    if (_checking) return;
    final tile = _tiles[index];
    if (tile.isFlipped || tile.isMatched) return;

    setState(() => tile.isFlipped = true);

    if (_firstFlipped == null) {
      _firstFlipped = index;
    } else {
      _moves++;
      _checking = true;
      final first = _tiles[_firstFlipped!];
      if (first.emoji == tile.emoji) {
        // Match!
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            first.isMatched = true;
            tile.isMatched = true;
            _matches++;
            _firstFlipped = null;
            _checking = false;
          });
          if (_matches == _totalPairs) {
            _timer.cancel();
            Future.delayed(const Duration(milliseconds: 300), _showResult);
          }
        });
      } else {
        // No match — flip back
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            first.isFlipped = false;
            tile.isFlipped = false;
            _firstFlipped = null;
            _checking = false;
          });
        });
      }
    }
  }

  String get _timerLabel {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get _starRating {
    if (_moves <= _totalPairs + 2) return '⭐⭐⭐';
    if (_moves <= _totalPairs * 2) return '⭐⭐';
    return '⭐';
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
                _starRating,
                style: const TextStyle(fontSize: 42, letterSpacing: 4),
              ),
              const SizedBox(height: 12),
              const Text(
                'Puzzle Solved!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 16),
              _StatRow(label: 'Moves', value: '$_moves'),
              const SizedBox(height: 6),
              _StatRow(label: 'Time', value: _timerLabel),
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
                        setState(_startGame);
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
              moves: _moves,
              matches: _matches,
              total: _totalPairs,
              timer: _timerLabel,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _tiles.length,
                  itemBuilder: (_, i) => _CardTile(
                    tile: _tiles[i],
                    color: _color,
                    onTap: () => _onTap(i),
                  ),
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
    required this.moves,
    required this.matches,
    required this.total,
    required this.timer,
    required this.onBack,
  });

  final Color color;
  final int moves, matches, total;
  final String timer;
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
              const SizedBox(width: 4),
              const Text(
                'Memory Puzzle',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                ),
              ),
              const Spacer(),
              _Chip(label: '⏱ $timer', color: color),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _Chip(label: '🕹 Moves: $moves', color: const Color(0xFF2D3142)),
                const SizedBox(width: 10),
                _Chip(label: '✅ $matches / $total', color: const Color(0xFF06D6A0)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: matches / total,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Card tile ────────────────────────────────────────────────────────────────

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.tile,
    required this.color,
    required this.onTap,
  });

  final _Tile tile;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) {
          final rotate = Tween<double>(begin: 0.5, end: 1.0).animate(anim);
          return RotationYTransition(turns: rotate, child: child);
        },
        child: tile.isFlipped || tile.isMatched
            ? _FaceUp(
                key: ValueKey('face_${tile.emoji}_${tile.hashCode}'),
                emoji: tile.emoji,
                matched: tile.isMatched,
                color: color,
              )
            : _FaceDown(
                key: ValueKey('back_${tile.hashCode}'),
                color: color,
              ),
      ),
    );
  }
}

class _FaceDown extends StatelessWidget {
  const _FaceDown({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Text('?', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _FaceUp extends StatelessWidget {
  const _FaceUp({super.key, required this.emoji, required this.matched, required this.color});
  final String emoji;
  final bool matched;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: matched ? const Color(0xFF06D6A0).withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: matched ? const Color(0xFF06D6A0) : color.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 36)),
      ),
    );
  }
}

// ── Rotation helper ──────────────────────────────────────────────────────────

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({super.key, required this.turns, required this.child})
      : super(listenable: turns);
  final Animation<double> turns;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final angle = (turns.value - 1.0) * 3.1416;
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────

class _Tile {
  _Tile({required this.emoji});
  final String emoji;
  bool isFlipped = false;
  bool isMatched = false;
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2D3142)),
        ),
      ],
    );
  }
}
