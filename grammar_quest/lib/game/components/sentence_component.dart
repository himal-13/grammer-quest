import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../grammar_game.dart';
import 'blank_slot_component.dart';

class SentenceComponent extends PositionComponent {
  final String text;
  final double maxWidth;
  final GrammarGame game;

  SentenceComponent({
    required this.text,
    required this.maxWidth,
    required this.game,
    required Vector2 position,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _layoutSentence();
  }

  void _layoutSentence() {
    final words = text.split(' ');
    double xOffset = 0;
    double yOffset = 0;
    const lineHeight = 50.0;
    const spaceWidth = 10.0;
    int blankIndex = 0;

    for (final word in words) {
      if (word.contains('___')) {
        // Handle blank slot
        final slotWidth = 80.0;
        if (xOffset + slotWidth > maxWidth) {
          xOffset = 0;
          yOffset += lineHeight;
        }
        
        final slot = BlankSlotComponent(
          correctWord: game.level.answers[blankIndex++],
          position: Vector2(xOffset, yOffset),
          size: Vector2(slotWidth, 30),
        );
        game.add(slot);
        game.blankSlots.add(slot);
        xOffset += slotWidth + spaceWidth;
      } else {
        // Handle normal word
        final textPainter = TextPainter(
          text: TextSpan(
            text: word,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (xOffset + textPainter.width > maxWidth) {
          xOffset = 0;
          yOffset += lineHeight;
        }

        final wordComp = TextComponent(
          text: word,
          position: Vector2(xOffset, yOffset),
          textRenderer: TextPaint(
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        );
        add(wordComp);
        xOffset += textPainter.width + spaceWidth;
      }
    }
    
    size = Vector2(maxWidth, yOffset + lineHeight);
  }
}
