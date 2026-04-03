import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import '../game/grammar_game.dart';
import '../data/models/level_model.dart';
import '../providers/coin_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/coin_display.dart';
import 'result_screen.dart';
import '../services/ad_service.dart';
class GameScreen extends StatefulWidget {
  final Level level;
  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GrammarGame _game;
  bool _errorsVisible = false;
  bool _showSuccessMessage = false;

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

    bool isFirstTime = !gameProvider.isLevelCompleted(widget.level.id);
    int xpGained = isFirstTime ? 200 : 50;
    int coinsEarned = 0; // Default to 0 for replay
    int stars = 0; // Stars are removed

    if (isFirstTime) {
      coinsEarned = (widget.level.id <= 5) ? 10 : 20;
      coinProvider.addCoins(coinsEarned);

      // Show beautiful dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.shade200, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Level Complete!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+$coinsEarned Coins',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToResultScreen(perfect, isFirstTime, xpGained, coinsEarned, stars);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      _navigateToResultScreen(perfect, isFirstTime, xpGained, coinsEarned, stars);
    }
    
    coinProvider.addXP(xpGained);
    gameProvider.completeLevel(widget.level.id, stars);
  }

  void _navigateToResultScreen(bool perfect, bool isFirstTime, int xpGained, int coinsEarned, int stars) {
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

  void _showErrors() {
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    if (coinProvider.spendCoins(20)) {
      _game.showErrors();
      setState(() {
        _errorsVisible = true;
        _showSuccessMessage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔍 Errors highlighted! Fix them and check again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _showNoCoinsDialog();
    }
  }

  void _resetErrorsAndReturnWords() {
    _game.resetErrorsAndReturnWords();
    setState(() {
      _errorsVisible = false;
      _showSuccessMessage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Error words returned to the bottom! Try again.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _checkAndShowSuccess() {
    if (_game.allAnswersCorrect) {
      setState(() {
        _showSuccessMessage = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ All answers are correct! Click CHECK ANSWER to complete the level.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      setState(() {
        _showSuccessMessage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAllFilled = _game.totalFilled == _game.blanksCount;
    final hasErrors = _game.hasErrors;
    final allCorrect = _game.allAnswersCorrect;
    
    // Determine if we should show the Show Errors button
    final shouldShowErrorsButton = isAllFilled && !_errorsVisible && !allCorrect;
    // Determine if we should show the Reset Errors button
    final shouldShowResetButton = _errorsVisible && hasErrors;
    // Determine if Check Answer button should be enabled
    final canCheckAnswers = isAllFilled && !hasErrors;

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
          
          // Success Message Overlay (when all answers are correct)
          if (_showSuccessMessage && isAllFilled && allCorrect)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.green.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: const Text(
                          'All answers correct! Click CHECK ANSWER to complete the level!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () {
                          setState(() {
                            _showSuccessMessage = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Top Buttons (Retry & Skip)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildGameButton(
                  icon: Icons.replay_rounded,
                  label: 'Retry',
                  onPressed: () {
                    setState(() {
                      _game.retry();
                      _errorsVisible = false;
                      _showSuccessMessage = false;
                    });
                  },
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
                      _showNoCoinsDialog();
                    }
                  },
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          
          // Bottom Buttons
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Hint button - only show when not all filled
                if (!isAllFilled)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildGameButton(
                      icon: Icons.lightbulb_outline_rounded,
                      label: 'Hint (20)',
                      onPressed: _useHint,
                      color: Colors.blue,
                    ),
                  ),
                
                // Show Errors button - only show when all filled, no errors visible yet, and NOT all correct
                if (shouldShowErrorsButton)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildGameButton(
                      icon: Icons.error_outline_rounded,
                      label: 'Show Errors (20)',
                      onPressed: _showErrors,
                      color: Colors.redAccent,
                    ),
                  ),
                
                // Reset Errors button - only show when errors are visible
                if (shouldShowResetButton)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildGameButton(
                      icon: Icons.refresh_rounded,
                      label: 'Reset Errors',
                      onPressed: _resetErrorsAndReturnWords,
                      color: Colors.orange,
                    ),
                  ),
                
                // Check Answer button
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: canCheckAnswers 
                      ? () {
                          if (allCorrect) {
                            _game.checkAnswers();
                          } else {
                            _checkAndShowSuccess();
                          }
                        }
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
                
                // Helper text based on state
                if (isAllFilled && !allCorrect && !_errorsVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Some answers may be incorrect. Click "Show Errors" to check!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                if (isAllFilled && allCorrect && !_errorsVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '✓ All answers correct! Click CHECK ANSWER to complete!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                if (isAllFilled && hasErrors)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '⚠️ Click "Reset Errors" to fix incorrect answers!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
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
          setState(() {
            _showSuccessMessage = false;
          });
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
      _showNoCoinsDialog();
    }
  }

  void _showNoCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Out of Coins!'),
        content: const Text('Watch a short video to get 20 coins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _watchAd();
            },
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
  }

  void _watchAd() {
    if (!AdService.isAdLoaded) {
      AdService.loadRewardedAd();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad is loading, please try again in a moment.')),
      );
      return;
    }
    
    AdService.showRewardedAd(
      onUserEarnedReward: (reward) {
        final coinProvider = Provider.of<CoinProvider>(context, listen: false);
        coinProvider.addCoins(20);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('💰 +20 coins received!')),
        );
      },
    );
  }
}