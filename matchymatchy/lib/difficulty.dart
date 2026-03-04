import 'package:flutter/material.dart';
import 'game.dart';

class Difficulty extends StatefulWidget {
  const Difficulty({super.key});

  @override
  State<Difficulty> createState() => _DifficultyState();
}

class _DifficultyState extends State<Difficulty>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _fadeIn;
  Animation<Offset>? _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeIn == null || _slideUp == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF81C784),
                  Color(0xFF4CAF50),
                  Color(0xFF388E3C),
                ],
              ),
            ),
          ),

          Positioned(top: -60, right: -60, child: _Circle(size: 200, opacity: 0.12)),
          Positioned(top: 120, left: -40, child: _Circle(size: 130, opacity: 0.08)),
          Positioned(bottom: -80, left: -40, child: _Circle(size: 260, opacity: 0.10)),
          Positioned(bottom: 130, right: -30, child: _Circle(size: 150, opacity: 0.09)),

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                SlideTransition(
                  position: _slideUp!,
                  child: FadeTransition(
                    opacity: _fadeIn!,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo2.png',
                          height: 250,
                        ),
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
                ),

                const Spacer(flex: 1),

                FadeTransition(
                  opacity: _fadeIn!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _DifficultyButton(
                          label: 'Easy',
                          onPressed: () =>Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const Game(difficulty: GameDifficulty.easy),
                          )),
                        ),
                        const SizedBox(height: 12),
                        _DifficultyButton(
                          label: 'Medium',
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const Game(difficulty: GameDifficulty.medium),
                          )),
                        ),
                        const SizedBox(height: 12),
                        _DifficultyButton(
                          label: 'Hard',
                          onPressed: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const Game(difficulty: GameDifficulty.hard),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                FadeTransition(
                  opacity: _fadeIn!,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
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
          ),
        ],
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DifficultyButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF388E3C),
          elevation: 6,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;

  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}