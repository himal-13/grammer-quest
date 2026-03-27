import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BlankSlotComponent extends PositionComponent {
  final String correctWord;
  String? filledWord;
  bool _isFilled = false;

  BlankSlotComponent({
    required this.correctWord,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = _isFilled ? Colors.green.shade400 : Colors.grey.shade300
      ..style = PaintingStyle.fill;
      
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    
    // Draw underline
    final borderPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.y), Offset(size.x, size.y), borderPaint);

    if (_isFilled && filledWord != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: filledWord,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas, 
        Offset((size.x - textPainter.width) / 2, (size.y - textPainter.height) / 2)
      );
    }
  }

  void fill(String word) {
    filledWord = word;
    _isFilled = true;
  }

  void clear() {
    filledWord = null;
    _isFilled = false;
  }
}
