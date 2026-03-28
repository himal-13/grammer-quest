import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import '../game/grammar_game.dart';
import '../data/models/level_model.dart';
import '../providers/coin_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/coin_display.dart';
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
      onStateChanged: () => setState(() {}),
    );
  }

  void _onLevelComplete(bool perfect) {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    int coinsEarned = 20;
    int xpGained = 50;
    int stars = 1;
    
    if (perfect) {
      coinsEarned += 40;
      xpGained += 50;
      stars = 3;
    } else {
      // Check if all blanks are filled (not necessarily perfect)
      if (_game.correctlyFilled == widget.level.blanks) {
        stars = 2;
      }
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
          stars: stars,
          completedParagraph: _game.getCompletedParagraph(),
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
        content: Text('❌ Wrong word! Try again.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.level.title),
            if (widget.level.contextHint.isNotEmpty)
              Text(
                widget.level.contextHint,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
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
          // Top Buttons (Retry & Skip)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildGameButton(
                  icon: Icons.replay_rounded,
                  label: 'Retry',
                  onPressed: () => setState(() => _game.retry()),
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildGameButton(
                  icon: Icons.skip_next_rounded,
                  label: 'Skip (40)',
                  onPressed: () {
                    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
                    if (coinProvider.spendCoins(40)) {
                      _game.skipLevel();
                    } else {
                      _showNoCoinsSnackBar();
                    }
                  },
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          // Bottom Buttons (Hint, Show Error, Check)
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_game.totalFilled > 0 && _game.totalFilled < _game.blanksCount)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildGameButton(
                      icon: Icons.help_outline_rounded,
                      label: 'Hint (20)',
                      onPressed: _useHint,
                      color: Colors.blue,
                    ),
                  ),
                if (_game.totalFilled == _game.blanksCount)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildGameButton(
                      icon: Icons.error_outline_rounded,
                      label: 'Show Errors (20)',
                      onPressed: () {
                        final coinProvider = Provider.of<CoinProvider>(context, listen: false);
                        if (coinProvider.spendCoins(20)) {
                          _game.showErrors();
                          setState(() {});
                        } else {
                          _showNoCoinsSnackBar();
                        }
                      },
                      color: Colors.redAccent,
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _game.totalFilled == _game.blanksCount 
                      ? () => _game.checkAnswers() 
                      : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('CHECK ANSWER', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        side: BorderSide(color: color, width: 1),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _useHint() {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    if (coinProvider.spendCoins(20)) {
      // Reveal one blank
      for (final slot in _game.blankSlots) {
        if (slot.filledWord == null) {
          slot.fill(slot.correctWord);
          _game.totalFilled++;
          setState(() {});
          if (_game.totalFilled == _game.blanksCount) {
            // Success call? No, wait for check.
          }
          break;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💡 Hint used! One blank filled.'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      _showNoCoinsSnackBar();
    }
  }

  void _showNoCoinsSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💰 Not enough coins! Complete levels to earn more.'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}