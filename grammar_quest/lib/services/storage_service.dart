import 'package:hive_ce_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static late Box _settingsBox;
  static late Box _gameBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    _gameBox = await Hive.openBox(AppConstants.gameBox);
  }

  // Settings
  static bool isDarkMode() => _settingsBox.get(AppConstants.darkModeKey, defaultValue: false);
  static Future<void> setDarkMode(bool value) => _settingsBox.put(AppConstants.darkModeKey, value);

  static bool isSoundEnabled() => _settingsBox.get(AppConstants.soundEnabledKey, defaultValue: true);
  static Future<void> setSoundEnabled(bool value) => _settingsBox.put(AppConstants.soundEnabledKey, value);

  // Game Data
  static int getCoins() => _gameBox.get(AppConstants.coinsKey, defaultValue: 100);
  static Future<void> saveCoins(int value) => _gameBox.put(AppConstants.coinsKey, value);

  static int getXP() => _gameBox.get(AppConstants.xpKey, defaultValue: 0);
  static Future<void> saveXP(int value) => _gameBox.put(AppConstants.xpKey, value);

  static int getUnlockedLevel() => _gameBox.get(AppConstants.unlockedLevelKey, defaultValue: 1);
  static Future<void> saveUnlockedLevel(int value) => _gameBox.put(AppConstants.unlockedLevelKey, value);

  static List<int> getCompletedLevels() => 
      List<int>.from(_gameBox.get(AppConstants.completedLevelsKey, defaultValue: <int>[]));
  
  static Future<void> markLevelCompleted(int levelId, int stars) async {
    final completed = getCompletedLevels();
    if (!completed.contains(levelId)) {
      completed.add(levelId);
      await _gameBox.put(AppConstants.completedLevelsKey, completed);
    }
    
    // Update stars if better than before
    final currentStars = getLevelStars(levelId);
    if (stars > currentStars) {
      final starsMap = Map<String, int>.from(_gameBox.get(AppConstants.levelStarsKey, defaultValue: <String, int>{}));
      starsMap[levelId.toString()] = stars;
      await _gameBox.put(AppConstants.levelStarsKey, starsMap);
    }
  }

  static int getLevelStars(int levelId) {
    final starsMap = Map<String, int>.from(_gameBox.get(AppConstants.levelStarsKey, defaultValue: <String, int>{}));
    return starsMap[levelId.toString()] ?? 0;
  }
}
