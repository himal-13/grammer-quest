import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/coin_provider.dart';
import '../providers/game_provider.dart';
import '../data/models/level_model.dart';
import '../data/level_data.dart';
import '../services/audio_service.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final Level level;
  final int coinsEarned;
  final int xpGained;
  final bool perfect;

  const ResultScreen({
    super.key,
    required this.level,
    required this.coinsEarned,
    required this.xpGained,
    required this.perfect,
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
    AudioService.playLevelComplete();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Level Complete!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final hasStar = index < (widget.perfect ? 3 : 1);
                      return Icon(
                        Icons.star_rounded,
                        size: 48,
                        color: hasStar ? Colors.amber : Colors.grey.withOpacity(0.3),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (widget.perfect)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Text(
                        'PERFECT!',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  const SizedBox(height: 48),
                  _buildStatRow(context, 'Coins Earned', '+${widget.coinsEarned}', Icons.monetization_on, Colors.amber),
                  const SizedBox(height: 16),
                  _buildStatRow(context, 'XP Gained', '+${widget.xpGained}', Icons.bolt, Colors.blue),
                  const Spacer(),
                  _buildActionButton(
                    context,
                    'Next Level',
                    Icons.skip_next_rounded,
                    () {
                      final nextLevel = LevelData.getLevel(widget.level.id + 1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen(level: nextLevel)),
                      );
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Replay',
                          Icons.replay_rounded,
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => GameScreen(level: widget.level)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Home',
                          Icons.home_rounded,
                          () => Navigator.of(context).popUntil((route) => route.isFirst),
                        ),
                      ),
                    ],
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
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: isPrimary 
          ? theme.elevatedButtonTheme.style
          : ElevatedButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
    );
  }
}
