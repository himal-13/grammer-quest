import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../data/models/level_model.dart';
import '../data/level_data.dart';
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
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    widget.stars == 3 ? 'Perfect!' : 'Level Complete!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 32, 
                      fontWeight: FontWeight.bold,
                      color: widget.stars == 3 ? Colors.amber : theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 16),
                  Text(
                    widget.level.title,
                    style: TextStyle(fontSize: isSmallScreen ? 16 : 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 24),
                  
                  // Stars display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final hasStar = index < widget.stars;
                      return Icon(
                        Icons.star_rounded,
                        size: isSmallScreen ? 48 : 64,
                        color: hasStar ? Colors.amber : Colors.grey.withOpacity(0.3),
                      );
                    }),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 16 : 32),
                  
                  // Stats in a row to save vertical space
                  Row(
                    children: [
                      Expanded(child: _buildMiniStat(context, '+${widget.coinsEarned}', Icons.monetization_on, Colors.amber)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMiniStat(context, '+${widget.xpGained}', Icons.bolt, Colors.blue)),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Buttons
                  Column(
                    children: [
                      if (widget.level.id < LevelData.getTotalLevels())
                        SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(
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
                    ],
                  ),
                  const SizedBox(height: 8),
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
                numberOfParticles: 20,
                gravity: 0.2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
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