import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/coin_provider.dart';
import '../data/level_data.dart';
import '../widgets/level_tile.dart';
import '../widgets/coin_display.dart';
import 'game_screen.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(child: CoinDisplay()),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: 60, // Total levels
            itemBuilder: (context, index) {
              final levelId = index + 1;
              final isUnlocked = game.isLevelUnlocked(levelId);
              final isCompleted = game.isLevelCompleted(levelId);
              final stars = game.getLevelStars(levelId);
              final isNext = levelId == game.unlockedLevel;

              return LevelTile(
                levelId: levelId,
                isUnlocked: isUnlocked,
                isCompleted: isCompleted,
                stars: stars,
                isNext: isNext,
                onTap: isUnlocked 
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(level: LevelData.getLevel(levelId)),
                      ),
                    )
                  : null,
              );
            },
          );
        },
      ),
    );
  }
}
