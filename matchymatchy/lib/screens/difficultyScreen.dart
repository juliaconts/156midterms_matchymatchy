import 'package:flutter/material.dart';
import '../config/difficultyConfig.dart';
import '../animations/animations.dart';
import '../widgets/decoratedScreen.dart';
import '../widgets/difficultyButton.dart';
import '../services/audio_manager.dart';
import 'gameScreen.dart';

// choosing difficulty sreen
class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen>
    with SingleTickerProviderStateMixin, ScreenAnimationMixin {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToGame(GameDifficulty difficulty) async {
    await AudioManager.stopBgm();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(difficulty: difficulty)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedScreenScaffold(
      child: Column(
        children: [
          const Spacer(flex: 2),
          fadeSlide(
            child: Column(
              children: [
                Image.asset('assets/logos/logo2.png', height: 250),
                Text(
                  'Choose a difficulty',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 15,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          fadeOnly(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  DifficultyButton(
                    label: 'Easy',
                    onPressed: () {
                      AudioManager.playButtonSfx();
                      _navigateToGame(GameDifficulty.easy);
                    },
                  ),
                  const SizedBox(height: 12),
                  DifficultyButton(
                    label: 'Medium',
                    onPressed: () {
                      AudioManager.playButtonSfx();
                      _navigateToGame(GameDifficulty.medium);
                    },
                  ),
                  const SizedBox(height: 12),
                  DifficultyButton(
                    label: 'Hard',
                    onPressed: () {
                      AudioManager.playButtonSfx();
                      _navigateToGame(GameDifficulty.hard);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          fadeOnly(
            child: TextButton(
              onPressed: () {
                AudioManager.playButtonSfx();
                Navigator.pop(context);
              },
              child: Text(
                'Back',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
