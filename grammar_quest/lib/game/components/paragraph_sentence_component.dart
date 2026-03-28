import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../grammar_game.dart';
import 'blank_slot_component.dart';

class ParagraphSentenceComponent extends PositionComponent {
  final String paragraph;
  final double maxWidth;
  final GrammarGame game;
  final double lineHeight = 28.0;
  final double fontSize = 16.0;

  ParagraphSentenceComponent({
    required this.paragraph,
    required this.maxWidth,
    required this.game,
    required Vector2 position,
  }) : super(position: position);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _layoutParagraph();
  }

  void _layoutParagraph() {
    // Split into sentences first
    final sentences = paragraph.split('. ');
    double yOffset = 0;
    int blankIndex = 0;
    
    for (var sentence in sentences) {
      if (!sentence.endsWith('.')) sentence = '$sentence.';
      
      final words = sentence.split(' ');
      double xOffset = 0;
      
      for (final word in words) {
        final isBlank = word.contains('___');
        
        if (isBlank) {
          // Handle blank slot
          final slotWidth = 85.0;
          if (xOffset + slotWidth > maxWidth) {
            xOffset = 0;
            yOffset += lineHeight;
          }
          
          final slot = BlankSlotComponent(
            correctWord: game.level.answers[blankIndex++],
            position: Vector2(xOffset, yOffset),
            size: Vector2(slotWidth, 24),
          );
          add(slot);
          game.blankSlots.add(slot);
          
          xOffset += slotWidth + 8;
        } else {
          // Handle normal word
          final textPainter = TextPainter(
            text: TextSpan(
              text: word,
              style: TextStyle(
                color: const Color(0xFF2D3436),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          
          final wordWidth = textPainter.width;
          
          if (xOffset + wordWidth > maxWidth) {
            xOffset = 0;
            yOffset += lineHeight;
          }
          
          final wordComp = TextComponent(
            text: word,
            position: Vector2(xOffset, yOffset),
            textRenderer: TextPaint(
              style: TextStyle(
                color: const Color(0xFF2D3436),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          add(wordComp);
          xOffset += wordWidth + 8;
        }
      }
      yOffset += lineHeight + 4; // Add space between sentences
    }
    
    size = Vector2(maxWidth, yOffset + 20);
  }
}