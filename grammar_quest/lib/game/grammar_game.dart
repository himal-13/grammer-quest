import 'package:flame/game.dart';
import 'package:flame/events.dart';
import '../data/models/level_model.dart';
import 'components/word_tile_component.dart';
import 'components/blank_slot_component.dart';
import 'components/sentence_component.dart';
import 'components/coin_effect_component.dart';

class GrammarGame extends FlameGame with DragCallbacks {
  final Level level;
  final Function(bool perfect)? onComplete;
  final Function(int coins, int xp)? onReward;
  final Function() onWrongAnswer;

  GrammarGame({
    required this.level,
    this.onComplete,
    this.onReward,
    required this.onWrongAnswer,
  });

  late SentenceComponent sentenceComponent;
  final List<WordTileComponent> wordTiles = [];
  final List<BlankSlotComponent> blankSlots = [];

  bool isPerfect = true;
  int correctlyFilled = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add components
    sentenceComponent = SentenceComponent(
      text: level.text,
      game: this,
      position: Vector2(20, 100),
      maxWidth: size.x - 40,
    );
    add(sentenceComponent);

    // Initial word bank setup is handled via overlay or here. 
    // In this case, we will place word tiles at the bottom.
    _setupWordBank();
  }

  void _setupWordBank() {
    final shuffledOptions = List<String>.from(level.options)..shuffle();
    const spacing = 10.0;
    const tileWidth = 100.0;
    const tileHeight = 40.0;
    
    final startY = size.y - 150;
    
    for (var i = 0; i < shuffledOptions.length; i++) {
        final x = 20 + (i % 3) * (tileWidth + spacing);
        final y = startY + (i / 3).floor() * (tileHeight + spacing);
        
        final tile = WordTileComponent(
          word: shuffledOptions[i],
          position: Vector2(x, y),
          size: Vector2(tileWidth, tileHeight),
        );
        wordTiles.add(tile);
        add(tile);
    }
  }

  void onWordDropped(WordTileComponent tile, Vector2 position) {
    for (final slot in blankSlots) {
      if (slot.containsPoint(position)) {
        if (slot.correctWord == tile.word) {
          // Correct!
          slot.fill(tile.word);
          tile.removeFromParent();
          correctlyFilled++;
          onReward?.call(2, 5);
          
          // Add coin effect
          add(CoinEffectComponent(position: slot.position.clone()));
          
          if (correctlyFilled == level.blanks) {
            onComplete?.call(isPerfect);
          }
          return;
        } else {
          // Wrong!
          isPerfect = false;
          onWrongAnswer();
          tile.shake();
          // tile.returnToOriginalPosition(); // Wait for shake?
          return;
        }
      }
    }
    tile.returnToOriginalPosition();
  }
}
