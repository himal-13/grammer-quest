import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../data/models/level_model.dart';
import '../data/level_data.dart';
import '../services/audio_service.dart';
import 'game_screen.dart';
import 'level_screen.dart';

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
    if (widget.stars >= 2) {
      _confettiController.play();
    }
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
                  Text(
                    widget.stars == 3 ? 'Perfect!' : 'Level Complete!',
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                      color: widget.stars == 3 ? Colors.amber : theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.level.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  // Stars display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final hasStar = index < widget.stars;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star_rounded,
                          size: 56,
                          color: hasStar ? Colors.amber : Colors.grey.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (widget.perfect)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade300, Colors.amber.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '⭐ PERFECT SCORE! ⭐',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  _buildStatRow(context, 'Coins Earned', '+${widget.coinsEarned}', Icons.monetization_on, Colors.amber),
                  const SizedBox(height: 12),
                  _buildStatRow(context, 'XP Gained', '+${widget.xpGained}', Icons.bolt, Colors.blue),
                  const SizedBox(height: 12),
                  _buildStatRow(context, 'Correct Answers', '${widget.stars == 3 ? widget.level.blanks : widget.level.blanks - 1}/${widget.level.blanks}', Icons.check_circle, Colors.green),
                  const SizedBox(height: 24),
                  // Completed Paragraph display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Review Paragraph:',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.completedParagraph,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Buttons
                  if (widget.level.id < LevelData.getTotalLevels())
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
                  const SizedBox(height: 12),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          'Levels',
                          Icons.grid_view_rounded,
                          () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LevelScreen()),
                            (route) => route.isFirst,
                          ),
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
          if (widget.stars >= 2)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple, Colors.amber],
                numberOfParticles: 50,
                gravity: 0.2,
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
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
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      onPressed: onPressed,
      style: isPrimary 
          ? theme.elevatedButtonTheme.style?.copyWith(
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            )
          : ElevatedButton.styleFrom(
              backgroundColor: theme.cardColor,
              foregroundColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
    );
  }
}