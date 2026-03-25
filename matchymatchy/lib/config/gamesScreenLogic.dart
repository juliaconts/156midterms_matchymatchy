import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../config/difficultyConfig.dart';
import '../models/cardModel.dart';
import '../services/audio_manager.dart';

// game logic and state management for the game screen

mixin GameScreenLogic<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late DifficultyConfig config;

  late List<CardModel> cards;
  late List<AnimationController> flipControllers;
  late List<Animation<double>> flipAnimations;

  List<int> flippedIndices = [];
  bool isChecking = false;
  bool gameWon = false;
  bool timeUp = false;

  late int secondsLeft;
  Timer? timer;

  void initGame(GameDifficulty difficulty) {
    config = DifficultyConfig.of(difficulty);

    final rng = Random();
    final shuffledImages = List<String>.from(config.assets)..shuffle(rng);

    final List<CardModel> deck = [];
    for (int i = 0; i < config.pairs; i++) {
      deck.add(CardModel(id: i, imagePath: shuffledImages[i]));
      deck.add(CardModel(id: i, imagePath: shuffledImages[i]));
    }

    // shuffle the deck
    deck.shuffle(rng);

    // initialize state
    cards = deck;
    flippedIndices = [];
    isChecking = false;
    gameWon = false;
    timeUp = false;
    secondsLeft = config.seconds;

    flipControllers = List.generate(
      cards.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      ),
    );

    flipAnimations = flipControllers
        .map(
          (c) => Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();

    startTimer();
  }

  // dispose all controllers and timers to prevent memory leaks
  void disposeGame() {
    timer?.cancel();
    for (final c in flipControllers) {
      c.dispose();
    }
  }

  void onGameWon() {} 

  // start the countdown timer
  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;

          if (secondsLeft <= 10) {
            AudioManager.startTickingSfx();
          }
        } else {
          timeUp = true;
          timer?.cancel();
          AudioManager.stopTickingSfx();
        }
      });
    });
  }

  // handle card tap logic
  void onCardTap(int index) {
    if (isChecking) return;
    if (cards[index].isMatched) return;
    if (cards[index].isFaceUp) return;
    if (flippedIndices.length == 2) return;
    if (gameWon || timeUp) return;

    AudioManager.playFlipSfx();

    setState(() {
      cards[index].isFaceUp = true;
      flippedIndices.add(index);
      flipControllers[index].forward();
    });

    if (flippedIndices.length == 2) checkMatch();
  }

  // checks if cards are matched
  void checkMatch() {
    isChecking = true;
    final a = flippedIndices[0];
    final b = flippedIndices[1];

    if (cards[a].id == cards[b].id) {
      AudioManager.playMatchSfx();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          cards[a].isMatched = true;
          cards[b].isMatched = true;
          flippedIndices = [];
          isChecking = false;
          if (cards.every((c) => c.isMatched)) {
            gameWon = true;
            timer?.cancel();
            onGameWon();
            AudioManager.stopTickingSfx();
          }
        });
      });
    } else {
      AudioManager.playWrongSfx();
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          cards[a].isFaceUp = false;
          cards[b].isFaceUp = false;
          flipControllers[a].reverse();
          flipControllers[b].reverse();
          flippedIndices = [];
          isChecking = false;
        });
      });
    }
  }

  // timer
  String get timerLabel {
    final m = secondsLeft ~/ 60;
    final s = secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // timer color
  Color get timerColor {
    if (secondsLeft > 30) return Colors.white;
    if (secondsLeft > 10) return Colors.yellow;
    return Colors.redAccent;
  }
}
