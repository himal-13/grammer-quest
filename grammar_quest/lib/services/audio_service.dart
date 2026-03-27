import 'package:audioplayers/audioplayers.dart';
import 'storage_service.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playSound(String fileName) async {
    if (!StorageService.isSoundEnabled()) return;
    
    try {
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  static void playCorrect() => playSound('correct.mp3');
  static void playWrong() => playSound('wrong.mp3');
  static void playLevelComplete() => playSound('level_complete.mp3');
}
