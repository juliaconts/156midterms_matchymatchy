import 'package:flutter/material.dart';
import 'package:matchymatchy/services/audio_manager.dart';
import '../widgets/decoratedScreen.dart';
import '../animations/animations.dart';
import 'difficultyScreen.dart';
import 'package:google_fonts/google_fonts.dart';

// home screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, ScreenAnimationMixin {
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();

    _scaleIn = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    AudioManager.playBgm();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedScreenScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          fadeSlide(child: Image.asset('assets/logos/matchy.png',
            width: 350,
            height: 250)),
          fadeSlide(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'flip cards, \n find matches, \n beat the clock.',
                textAlign: TextAlign.center,
                style: GoogleFonts.indieFlower(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const Spacer(flex: 3),
          ScaleTransition(
              scale: _scaleIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GestureDetector(
                  onTap: () {
                    AudioManager.playButtonSfx(); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DifficultyScreen()),
                    );
                  },
                  child: SizedBox(
                    height: 58,
                    child: Center(
                      child: Text(
                        'play',
                        style: GoogleFonts.indieFlower(
                          color: const Color.fromARGB(255, 254, 255, 213),
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}