import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BlankSlotComponent extends PositionComponent {
  final String correctWord;
  String? filledWord;
  bool _isFilled = false;
  bool isError = false;

  BlankSlotComponent({
    required this.correctWord,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    
    // Background
    final paint = Paint()
      ..color = isError 
          ? Colors.red.withOpacity(0.1)
          : (_isFilled 
              ? const Color(0xFF2ECC71).withOpacity(0.15) 
              : Colors.grey.shade100)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rRect, paint);
    
    // Border with dashed effect for empty slots
    if (isError) {
      final borderPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(rRect, borderPaint);
    } else if (!_isFilled) {
      final borderPaint = Paint()
        ..color = Colors.grey.shade400
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(rRect, borderPaint);
      
      // Draw dotted line effect
      final dashPaint = Paint()
        ..color = Colors.grey.shade400
        ..strokeWidth = 1;
      for (var i = 0.0; i < size.x; i += 8) {
        canvas.drawLine(
          Offset(i, size.y / 2),
          Offset(i + 4, size.y / 2),
          dashPaint,
        );
      }
    } else {
      // Filled border
      final borderPaint = Paint()
        ..color = const Color(0xFF2ECC71)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(rRect, borderPaint);
    }

    if (_isFilled && filledWord != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: filledWord,
          style: TextStyle(
            color: isError ? Colors.red : const Color(0xFF27AD60), 
            fontWeight: FontWeight.bold, 
            fontSize: 14
          ),
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
    isError = false;
  }

  void clear() {
    filledWord = null;
    _isFilled = false;
    isError = false;
  }
}