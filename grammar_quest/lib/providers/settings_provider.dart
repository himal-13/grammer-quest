import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = StorageService.isDarkMode();
  bool _soundEnabled = StorageService.isSoundEnabled();

  bool get isDarkMode => _isDarkMode;
  bool get soundEnabled => _soundEnabled;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    StorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    StorageService.setSoundEnabled(_soundEnabled);
    notifyListeners();
  }
}
