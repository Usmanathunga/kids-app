import 'package:flutter/material.dart';

class DrawingActivityScreen extends StatefulWidget {
  const DrawingActivityScreen({super.key});

  @override
  State<DrawingActivityScreen> createState() => _DrawingActivityScreenState();
}

class _DrawingActivityScreenState extends State<DrawingActivityScreen> {
  static const _color = Color(0xFF06D6A0);

  final List<_Stroke> _strokes = [];
  final List<List<_Stroke>> _undoStack = [];
  _Stroke? _current;

  Color _selectedColor = const Color(0xFF2D3142);
  double _strokeWidth = 5;
  bool _isEraser = false;

  final GlobalKey _canvasKey = GlobalKey();

  static const _palette = [
    Color(0xFF2D3142),
    Color(0xFFFF6B6B),
    Color(0xFFFF8C42),
    Color(0xFFFFD166),
    Color(0xFF06D6A0),
    Color(0xFF4ECDC4),
    Color(0xFF7C83FD),
    Color(0xFFFF6B9D),
    Color(0xFFFFFFFF),
  ];

  static const _brushSizes = [3.0, 6.0, 12.0, 20.0];

  void _onPanStart(DragStartDetails d) {
    _undoStack.add(List.of(_strokes));
    setState(() {
      _current = _Stroke(
        color: _isEraser ? Colors.white : _selectedColor,
        width: _isEraser ? _strokeWidth * 3 : _strokeWidth,
        points: [d.localPosition],
      );
      _strokes.add(_current!);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _current!.points.add(d.localPosition));
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() => _current = null);
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      _strokes
        ..clear()
        ..addAll(_undoStack.removeLast());
    });
  }

  void _clear() {
    _undoStack.add(List.of(_strokes));
    setState(() => _strokes.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              color: _color,
              onBack: () => Navigator.pop(context),
              onUndo: _undoStack.isNotEmpty ? _undo : null,
              onClear: _clear,
            ),
            // Canvas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  key: _canvasKey,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      painter: _CanvasPainter(_strokes),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tools panel
            _ToolsPanel(
              selectedColor: _selectedColor,
              strokeWidth: _strokeWidth,
              isEraser: _isEraser,
              palette: _palette,
              brushSizes: _brushSizes,
              onColorPick: (c) => setState(() {
                _selectedColor = c;
                _isEraser = false;
              }),
              onSizePick: (s) => setState(() => _strokeWidth = s),
              onEraserToggle: () => setState(() => _isEraser = !_isEraser),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.color,
    required this.onBack,
    required this.onUndo,
    required this.onClear,
  });

  final Color color;
  final VoidCallback onBack;
  final VoidCallback? onUndo;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF2D3142),
          ),
          const SizedBox(width: 4),
          const Text(
            'Drawing Canvas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3142),
            ),
          ),
          const Spacer(),
          _IconBtn(
            icon: Icons.undo_rounded,
            tooltip: 'Undo',
            onTap: onUndo,
            color: const Color(0xFF2D3142),
          ),
          const SizedBox(width: 4),
          _IconBtn(
            icon: Icons.delete_outline_rounded,
            tooltip: 'Clear',
            onTap: onClear,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: onTap != null
                ? color.withValues(alpha: 0.10)
                : Colors.grey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 22,
            color: onTap != null ? color : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

// ── Tools panel ──────────────────────────────────────────────────────────────

class _ToolsPanel extends StatelessWidget {
  const _ToolsPanel({
    required this.selectedColor,
    required this.strokeWidth,
    required this.isEraser,
    required this.palette,
    required this.brushSizes,
    required this.onColorPick,
    required this.onSizePick,
    required this.onEraserToggle,
  });

  final Color selectedColor;
  final double strokeWidth;
  final bool isEraser;
  final List<Color> palette;
  final List<double> brushSizes;
  final ValueChanged<Color> onColorPick;
  final ValueChanged<double> onSizePick;
  final VoidCallback onEraserToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color palette
            Row(
              children: [
                const _Label('Colors'),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: palette.map((c) {
                        final selected = !isEraser && selectedColor == c;
                        return GestureDetector(
                          onTap: () => onColorPick(c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 8),
                            width: selected ? 34 : 28,
                            height: selected ? 34 : 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF2D3142)
                                    : Colors.grey.shade300,
                                width: selected ? 3 : 1.5,
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: c.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Brush size + eraser
            Row(
              children: [
                const _Label('Size'),
                const SizedBox(width: 12),
                ...brushSizes.map((s) {
                  final selected = !isEraser && strokeWidth == s;
                  return GestureDetector(
                    onTap: () => onSizePick(s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 10),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: selected
                            ? selectedColor.withValues(alpha: 0.15)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? selectedColor : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: s.clamp(3, 20),
                          height: s.clamp(3, 20),
                          decoration: BoxDecoration(
                            color: selected ? selectedColor : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                // Eraser button
                GestureDetector(
                  onTap: onEraserToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isEraser
                          ? const Color(0xFF7C83FD).withValues(alpha: 0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isEraser
                            ? const Color(0xFF7C83FD)
                            : Colors.grey.shade300,
                        width: isEraser ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_fix_high_rounded,
                          size: 18,
                          color: isEraser
                              ? const Color(0xFF7C83FD)
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Eraser',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isEraser
                                ? const Color(0xFF7C83FD)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
      ),
    );
  }
}

// ── Painter ──────────────────────────────────────────────────────────────────

class _CanvasPainter extends CustomPainter {
  _CanvasPainter(this.strokes);
  final List<_Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (var i = 1; i < stroke.points.length; i++) {
        final prev = stroke.points[i - 1];
        final curr = stroke.points[i];
        path.quadraticBezierTo(
          prev.dx, prev.dy,
          (prev.dx + curr.dx) / 2,
          (prev.dy + curr.dy) / 2,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CanvasPainter old) => true;
}

// ── Model ────────────────────────────────────────────────────────────────────

class _Stroke {
  _Stroke({required this.color, required this.width, required this.points});
  final Color color;
  final double width;
  final List<Offset> points;
}
