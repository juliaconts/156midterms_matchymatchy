import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer player = AudioPlayer();

  static Future<void> playBgm() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(0.5);
    await player.play(AssetSource('sounds/bgm.mp3'));
  }

  static Future<void> stopBgm() async {
    await player.stop();
    await player.release();
  }

  static Future<void> playWinSfx() async {
    final sfxPlayer = AudioPlayer();
    await sfxPlayer.play(AssetSource('sounds/yippee-tbh.mp3'));
    sfxPlayer.onPlayerComplete.listen((_) => sfxPlayer.dispose());
  }

  static Future<void> playLoseSfx() async {
    final sfxPlayer = AudioPlayer();
    await sfxPlayer.play(AssetSource('sounds/downer_noise.mp3'));
    sfxPlayer.onPlayerComplete.listen((_) => sfxPlayer.dispose());
  }
}
