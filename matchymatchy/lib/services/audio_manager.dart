import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:js_interop';

@JS('resumeAudioContext')
external void resumeAudioContext();

@JS('playSound')
external void playSound(String name);

class AudioManager {
  static final AudioPlayer bgmPlayer = AudioPlayer();

  static Future<void> init() async {
    // SFX handled by Web Audio API in index.html
  }

  static Future<void> playBgm() async {
    if (kIsWeb) resumeAudioContext();
    await bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await bgmPlayer.setVolume(0.5);
    await bgmPlayer.play(UrlSource('assets/sounds/bgm.mp3'));
  }

  static Future<void> stopBgm() async => await bgmPlayer.stop();

  static void playFlipSfx() {
    if (kIsWeb) playSound('flip');
  }

  static void playMatchSfx() {
    if (kIsWeb) playSound('match');
  }

  static void playWrongSfx() {
    if (kIsWeb) playSound('wrong');
  }

  static void playWinSfx() {
    if (kIsWeb) playSound('win');
  }

  static void playLoseSfx() {
    if (kIsWeb) playSound('lose');
  }

  static void playButtonSfx() {
    if (kIsWeb) playSound('button');
  }

  static bool _ticking = false;

  static void startTickingSfx() {
    if (_ticking) return;
    _ticking = true;
    if (kIsWeb) playSound("clock-tick");
  }

  static void stopTickingSfx() {
    _ticking = false;
  }
}
