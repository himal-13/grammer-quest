import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../data/models/level_model.dart';
import 'components/word_tile_component.dart';
import 'components/blank_slot_component.dart';
import 'components/paragraph_sentence_component.dart';

class GrammarGame extends FlameGame with DragCallbacks {
  final Level level;
  final Function(bool perfect)? onComplete;
  final Function(int coins, int xp)? onReward;
  final Function() onWrongAnswer;
  final Function()? onStateChanged;

  GrammarGame({
    required this.level,
    this.onComplete,
    this.onReward,
    required this.onWrongAnswer,
    this.onStateChanged,
  });

  late ParagraphSentenceComponent paragraphComponent;
  final List<WordTileComponent> wordTiles = [];
  final List<BlankSlotComponent> blankSlots = [];

  bool isPerfect = true;
  int correctlyFilled = 0;
  int totalFilled = 0;

  int get blanksCount => level.blanks;

  @override
  Color backgroundColor() => const Color(0xFFF8F9FA);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add paragraph component
    paragraphComponent = ParagraphSentenceComponent(
      paragraph: level.paragraph,
      game: this,
      position: Vector2(20, 80),
      maxWidth: size.x - 40,
    );
    add(paragraphComponent);

    _setupWordBank();
  }

  void _setupWordBank() {
    final shuffledOptions = List<String>.from(level.options)..shuffle();
    const spacing = 12.0;
    const tileHeight = 48.0;
    
    // Calculate layout for word tiles at the bottom
    double xOffset = 20.0;
    double yOffset = size.y - 140;
    
    for (var i = 0; i < shuffledOptions.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: shuffledOptions[i],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      final tileWidth = textPainter.width + 32;
      
      if (xOffset + tileWidth > size.x - 20) {
        xOffset = 20.0;
        yOffset += tileHeight + spacing;
        
        // If too many rows, adjust starting position
        if (yOffset + tileHeight > size.y - 20) {
          yOffset = size.y - 140;
          xOffset = 20.0;
        }
      }

      final tile = WordTileComponent(
        word: shuffledOptions[i],
        position: Vector2(xOffset, yOffset),
        size: Vector2(tileWidth, tileHeight),
      );
      wordTiles.add(tile);
      add(tile);
      
      xOffset += tileWidth + spacing;
    }
  }

  void onWordTapped(WordTileComponent tile) {
    // Find first empty slot
    for (final slot in blankSlots) {
      if (slot.filledWord == null) {
        slot.fill(tile.word);
        tile.removeFromParent();
        totalFilled++;
        onStateChanged?.call();
        return;
      }
    }
  }

  bool checkAnswers() {
    int currentCorrect = 0;
    bool allCorrect = true;
    
    for (final slot in blankSlots) {
      if (slot.filledWord == slot.correctWord) {
        currentCorrect++;
      } else {
        allCorrect = false;
        isPerfect = false;
      }
    }
    
    correctlyFilled = currentCorrect;
    
    if (allCorrect) {
      onComplete?.call(isPerfect);
    } else {
      onWrongAnswer();
    }
    
    return allCorrect;
  }

  void showErrors() {
    for (final slot in blankSlots) {
      if (slot.filledWord != null && slot.filledWord != slot.correctWord) {
        slot.isError = true;
      }
    }
  }

  void retry() {
    // Clear all slots
    for (final slot in blankSlots) {
      slot.clear();
    }
    totalFilled = 0;
    correctlyFilled = 0;
    isPerfect = true;
    
    // Reset word tiles (this is tricky because they were removed)
    // Simplest is to reload the word bank
    _resetWordBank();
  }

  void _resetWordBank() {
    // Remove existing tiles if any (though they are mostly gone)
    for (var tile in wordTiles) {
      if (tile.isMounted) {
        tile.removeFromParent();
      }
    }
    wordTiles.clear();
    _setupWordBank();
  }

  void skipLevel() {
    // Fill all slots correctly and complete
    for (final slot in blankSlots) {
      slot.fill(slot.correctWord);
    }
    correctlyFilled = level.blanks;
    totalFilled = level.blanks;
    onComplete?.call(false); // Not perfect if skipped
  }

  String getCompletedParagraph() {
    String p = level.paragraph;
    for (final slot in blankSlots) {
      p = p.replaceFirst('___', slot.correctWord);
    }
    return p;
  }
}