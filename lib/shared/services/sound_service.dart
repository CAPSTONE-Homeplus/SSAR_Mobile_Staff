import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final _player = AudioPlayer();

  static Future<void> playNotification() async {
    try {
      await _player.play(
        AssetSource('sounds/notify.wav'),
        volume: 1.0,
      );
    } catch (e) {
      print("🔈 Lỗi khi phát âm thanh: $e");
    }
  }
}
