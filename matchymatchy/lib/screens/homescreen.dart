import 'package:flutter/material.dart';
import 'package:matchymatchy/services/audio_manager.dart';
import '../widgets/decoratedScreen.dart';
import '../animations/animations.dart';
import 'difficultyScreen.dart';

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
          fadeSlide(child: Image.asset('assets/logos/logo.png', height: 450)),
          const Spacer(flex: 3),
          ScaleTransition(
            scale: _scaleIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DifficultyScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 24, 81, 41),
                    foregroundColor: const Color.fromARGB(255, 40, 94, 42),
                    elevation: 6,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
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
