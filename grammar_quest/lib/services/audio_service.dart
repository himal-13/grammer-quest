import 'package:audioplayers/audioplayers.dart';
import 'storage_service.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playSound(String fileName) async {
    if (!StorageService.isSoundEnabled()) return;
    
    try {
      // Create a new player for each sound to allow overlapping sounds if needed
      // or just use one for minimal and Dispose it properly.
      // For minimal in-game sounds, a single player is fine if we stop the previous one.
      await _player.stop();
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  static void playSuccess() => playSound('success.mp3');
  static void playFailed() => playSound('failed.mp3');
  static void playLevelComplete() => playSound('level-complete.mp3');
  static void playGameOver() => playSound('gameover.mp3');
  
  // Aliases for game events
  static void playCorrect() => playSuccess();
  static void playWrong() => playFailed();
}

