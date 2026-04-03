import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:grammar_quest/data/level_data.dart';
import 'package:grammar_quest/data/models/level_model.dart';
import 'package:grammar_quest/screens/game_screen.dart';

import '../services/ad_service.dart';
import '../providers/coin_provider.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final Level level;
  final int coinsEarned;
  final int xpGained;
  final bool perfect;
  final int stars;
  final String completedParagraph;

  const ResultScreen({
    super.key,
    required this.level,
    required this.coinsEarned,
    required this.xpGained,
    required this.perfect,
    required this.stars,
    required this.completedParagraph,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    AdService.loadRewardedAd();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showAdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Earn Coins'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Level Completed!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.level.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // XP Gained
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.blue, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            '+${widget.xpGained} XP',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Full Paragraph Display
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          widget.completedParagraph,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Reward Ad Button
                  OutlinedButton.icon(
                    onPressed: _showAdDialog,
                    icon: const Icon(Icons.video_collection_rounded, color: Colors.amber),
                    label: const Text('Watch Ad for 20 💰', style: TextStyle(color: Colors.amber)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen(level: widget.level)),
                          ),
                          child: const Text('Replay'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.level.id < LevelData.getTotalLevels())
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final nextLevel = LevelData.getLevel(widget.level.id + 1);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => GameScreen(level: nextLevel)),
                              );
                            },
                            style: theme.elevatedButtonTheme.style,
                            child: const Text('Next Level'),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  TextButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.amber],
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }




}