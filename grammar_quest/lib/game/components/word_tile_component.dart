import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../grammar_game.dart';

class WordTileComponent extends PositionComponent with TapCallbacks, HasGameRef<GrammarGame> {
  final String word;
  late Vector2 originalPosition;

  WordTileComponent({
    required this.word,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    originalPosition = position.clone();
  }

  @override
  void render(Canvas canvas) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    
    // Draw shadow
    canvas.drawRRect(rRect.shift(const Offset(0, 2)), shadowPaint);

    final paint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..style = PaintingStyle.fill;
      
    canvas.drawRRect(rRect, paint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: word,
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 16
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

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.onWordTapped(this);
  }

  void shake() {
    add(
      SequenceEffect([
        MoveByEffect(Vector2(-5, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
      ]),
    );
  }

  void returnToOriginalPosition() {
    position.setFrom(originalPosition);
  }
}
