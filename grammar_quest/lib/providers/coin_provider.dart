import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CoinProvider extends ChangeNotifier {
  int _coins = StorageService.getCoins();
  int _xp = StorageService.getXP();

  int get coins => _coins;
  int get xp => _xp;

  void addCoins(int amount) {
    _coins += amount;
    StorageService.saveCoins(_coins);
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      StorageService.saveCoins(_coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  void addXP(int amount) {
    _xp += amount;
    StorageService.saveXP(_xp);
    notifyListeners();
  }

  int get currentLevelXP {
    int level = 1;
    int remainingXP = _xp;
    while (true) {
      int requiredXP = 200 + level * 100;
      if (remainingXP >= requiredXP) {
        remainingXP -= requiredXP;
        level++;
      } else {
        break;
      }
    }
    return level;
  }

  double get xpProgress {
    int level = 1;
    int remainingXP = _xp;
    int requiredXP = 200 + level * 100;
    while (true) {
      if (remainingXP >= requiredXP) {
        remainingXP -= requiredXP;
        level++;
        requiredXP = 200 + level * 100;
      } else {
        break;
      }
    }
    return remainingXP / requiredXP;
  }
}
