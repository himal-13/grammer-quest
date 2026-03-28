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

  double get xpProgress {
    // Simple XP logic: 100 XP per level
    return (_xp % 100) / 100.0;
  }

  int get currentLevelXP => (_xp / 100).floor() + 1;
}
