import 'package:flutter/material.dart';
import '../config/difficultyConfig.dart';
import '../config/gamesScreenLogic.dart';
import '../widgets/gameScreenWidgets.dart';

// game screen

class GameScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const GameScreen({super.key, this.difficulty = GameDifficulty.easy});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin, GameScreenLogic, GameScreenWidgets {
  @override
  GameDifficulty get difficulty => widget.difficulty;

  @override
  void initState() {
    super.initState();
    initGame(widget.difficulty);
  }

  @override
  void dispose() {
    disposeGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (gameWon || timeUp) return buildEndScreen();
    return buildGameScreen();
  }
}