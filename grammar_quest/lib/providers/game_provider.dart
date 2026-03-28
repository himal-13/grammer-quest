import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  int _unlockedLevel = StorageService.getUnlockedLevel();
  List<int> _completedLevels = StorageService.getCompletedLevels();

  int get unlockedLevel => _unlockedLevel;
  List<int> get completedLevels => _completedLevels;

  bool isLevelUnlocked(int levelId) {
    return levelId <= _unlockedLevel;
  }

  bool isLevelCompleted(int levelId) {
    return _completedLevels.contains(levelId);
  }

  int getLevelStars(int levelId) {
    return StorageService.getLevelStars(levelId);
  }

  void completeLevel(int levelId, int stars) {
    if (!_completedLevels.contains(levelId)) {
      _completedLevels.add(levelId);
    }
    StorageService.markLevelCompleted(levelId, stars);
    
    // Unlock next level if this was the highest unlocked level
    if (levelId == _unlockedLevel) {
      _unlockedLevel++;
      StorageService.saveUnlockedLevel(_unlockedLevel);
    }
    notifyListeners();
  }
}
