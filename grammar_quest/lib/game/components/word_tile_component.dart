import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../grammar_game.dart';

class WordTileComponent extends PositionComponent with DragCallbacks, TapCallbacks, HasGameRef<GrammarGame> {
  final String word;
  late Vector2 originalPosition;
  bool _isDragging = false;

  WordTileComponent({
    required this.word,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    originalPosition = position.clone();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = _isDragging ? Colors.blue.withOpacity(0.8) : Colors.blue.shade400
      ..style = PaintingStyle.fill;
      
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: word,
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

  @override
  void onDragStart(DragStartEvent event) {
    _isDragging = true;
    priority = 100; // Bring to front
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    priority = 0;
    gameRef.onWordDropped(this, position + size / 2);
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.onWordDropped(this, position + size / 2);
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
