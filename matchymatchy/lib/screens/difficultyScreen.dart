import 'package:flutter/material.dart';
import '../config/difficultyConfig.dart';
import '../animations/animations.dart';
import '../widgets/decoratedScreen.dart';
import '../widgets/difficultyButton.dart';
import '../services/audio_manager.dart';
import 'gameScreen.dart';
import 'package:google_fonts/google_fonts.dart';

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
          fadeOnly(
            child: Column(
              children: [
                SizedBox(
                  width: 450,
                  height: 300,
                  child: Image.asset(
                    'assets/logos/matchy.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'choose a difficulty',
                  style: GoogleFonts.indieFlower(
                    color: const Color.fromARGB(255, 254, 255, 213),
                    fontSize: 28,
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
                'back',
                style: GoogleFonts.indieFlower(
                  color: const Color.fromARGB(255, 254, 255, 213),
                  fontSize: 20,
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
