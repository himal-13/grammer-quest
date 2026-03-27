import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import '../game/grammar_game.dart';
import '../data/models/level_model.dart';
import '../providers/coin_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/coin_display.dart';
import '../widgets/hint_button.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GrammarGame _game;

  @override
  void initState() {
    super.initState();
    _game = GrammarGame(
      level: widget.level,
      onComplete: (perfect) => _onLevelComplete(perfect),
      onReward: (coins, xp) => _onReward(coins, xp),
      onWrongAnswer: () => _onWrongAnswer(),
    );
  }

  void _onLevelComplete(bool perfect) {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    int coinsEarned = 20;
    int xpGained = 50;
    int stars = 1;
    
    if (perfect) {
      coinsEarned += 20;
      xpGained += 25;
      stars = 3;
    }

    coinProvider.addCoins(coinsEarned);
    coinProvider.addXP(xpGained);
    gameProvider.completeLevel(widget.level.id, stars);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          level: widget.level,
          coinsEarned: coinsEarned,
          xpGained: xpGained,
          perfect: perfect,
        ),
      ),
    );
  }

  void _onReward(int coins, int xp) {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    coinProvider.addCoins(coins);
    coinProvider.addXP(xp);
  }

  void _onWrongAnswer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wrong word! Try again.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level.id}'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: CoinDisplay()),
          ),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(
            bottom: 24,
            right: 24,
            child: HintButton(
              onHint: () {
                final coinProvider = Provider.of<CoinProvider>(context, listen: false);
                if (coinProvider.spendCoins(20)) {
                  // Reveal one blank
                  for (final slot in _game.blankSlots) {
                    if (slot.filledWord == null) {
                      slot.fill(slot.correctWord);
                      _game.correctlyFilled++;
                      if (_game.correctlyFilled == _game.level.blanks) {
                        _onLevelComplete(_game.isPerfect);
                      }
                      break;
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not enough coins!')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
