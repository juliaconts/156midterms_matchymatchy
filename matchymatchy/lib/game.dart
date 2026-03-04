import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ── Difficulty config ─────────────────────────────────────────────────────────

enum GameDifficulty { easy, medium, hard }

extension GameDifficultyLabel on GameDifficulty {
  String get label {
    switch (this) {
      case GameDifficulty.easy:   return 'EASY';
      case GameDifficulty.medium: return 'MEDIUM';
      case GameDifficulty.hard:   return 'HARD';
    }
  }
}

class _DifficultyConfig {
  final int pairs;
  final int seconds;
  final int crossAxisCount;
  final double childAspectRatio;

  const _DifficultyConfig({
    required this.pairs,
    required this.seconds,
    required this.crossAxisCount,
    required this.childAspectRatio,
  });

  int get totalCards => pairs * 2;

  factory _DifficultyConfig.of(GameDifficulty d) {
    // returns the config based on the difficulty level
    switch (d) {
      case GameDifficulty.easy:
        return const _DifficultyConfig(pairs: 3, seconds: 50,  crossAxisCount: 3, childAspectRatio: 0.68);
      case GameDifficulty.medium:
        return const _DifficultyConfig(pairs: 6, seconds: 40, crossAxisCount: 3, childAspectRatio: 0.90);
      case GameDifficulty.hard:
        return const _DifficultyConfig(pairs: 8, seconds: 30,  crossAxisCount: 4, childAspectRatio: 0.72);
    }
  }
}

// colors 
const List<Color> _colorPool = [
  Color(0xFFE53935), 
  Color.fromARGB(255, 19, 70, 113),
  Color(0xFFFDD835), 
  Color(0xFF8E24AA), 
  Color.fromARGB(255, 255, 71, 15), 
  Color.fromARGB(255, 152, 243, 255), 
  Color.fromARGB(255, 14, 67, 17), 
  Color.fromARGB(255, 110, 80, 10), 
];

// card model 

class CardModel {
  final int id;
  final Color color;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.color,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

// game widget
class Game extends StatefulWidget {
  final GameDifficulty difficulty;

  const Game({super.key, this.difficulty = GameDifficulty.easy});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late final _DifficultyConfig _config;

  late List<CardModel> _cards;
  late List<AnimationController> _flipControllers;
  late List<Animation<double>> _flipAnimations;

  List<int> _flippedIndices = [];
  bool _isChecking = false;
  bool _gameWon = false;
  bool _timeUp = false;

  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // changes based on the difficulty level
    _config = _DifficultyConfig.of(widget.difficulty);
    _initGame();
  }

  void _initGame() {
    final rng = Random();

    // picks random colors and creates pair
    final shuffledColors = List<Color>.from(_colorPool)..shuffle(rng);

    // matches the numver of pairs
    final List<CardModel> deck = [];
    for (int i = 0; i < _config.pairs; i++) {
      deck.add(CardModel(id: i, color: shuffledColors[i]));
      deck.add(CardModel(id: i, color: shuffledColors[i]));
    }
    // shuffles the deck -- makes sure that every game, cards are in different positions
    deck.shuffle(rng);

    // initializes the game state
    _cards = deck;
    _flippedIndices = [];
    _isChecking = false;
    _gameWon = false;
    _timeUp = false;
    _secondsLeft = _config.seconds;

    // time it takes for the card to flip
    _flipControllers = List.generate(
      _cards.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      ),
    );

    _flipAnimations = _flipControllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _flipControllers) {
      c.dispose();
    }
    super.dispose();
  }

// timer logic
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timeUp = true;
          _timer?.cancel();
        }
      });
    });
  }


// flip logic
  void _onCardTap(int index) {

    // checking if the card can be flipped
    if (_isChecking) return;
    if (_cards[index].isMatched) return;
    if (_cards[index].isFaceUp) return;
    if (_flippedIndices.length == 2) return;
    if (_gameWon || _timeUp) return;

    // if all checks are passed, flip the card
    setState(() {
      _cards[index].isFaceUp = true;
      _flippedIndices.add(index);
      _flipControllers[index].forward();
    });

    // if second card is flipped, check if match
    if (_flippedIndices.length == 2) _checkMatch();
  }

  void _checkMatch() {
    _isChecking = true;
    final a = _flippedIndices[0];
    final b = _flippedIndices[1];

    // if matching cards -- lock the card face up
    if (_cards[a].id == _cards[b].id) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _cards[a].isMatched = true;
          _cards[b].isMatched = true;
          _flippedIndices = []; // puts the card in the flipped state s
          _isChecking = false;
          if (_cards.every((c) => c.isMatched)) {
            _gameWon = true;
            _timer?.cancel();
          }
        });
      });
    } else { // flip the card back after a short delay
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _cards[a].isFaceUp = false;
          _cards[b].isFaceUp = false;
          _flipControllers[a].reverse();
          _flipControllers[b].reverse();
          _flippedIndices = []; // removes the card from the flipped state
          _isChecking = false;
        });
      });
    }
  }

// converts the seconds left into a mm:ss format
  String get _timerLabel {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

// change the color based on time left
  Color get _timerColor {
    if (_secondsLeft > 30) return Colors.white;
    if (_secondsLeft > 10) return Colors.yellow;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    if (_gameWon || _timeUp) return _buildEndScreen();
    return _buildGameScreen();
  }

  Widget _buildBackground() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF81C784), Color(0xFF4CAF50), Color(0xFF388E3C)],
          ),
        ),
      );

  Widget _buildGameScreen() {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Positioned(top: -60, right: -60, child: _Circle(size: 200, opacity: 0.10)),
          Positioned(bottom: -80, left: -40, child: _Circle(size: 260, opacity: 0.09)),
          SafeArea(
            child: Column(
              children: [
                // timer and exit button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timer_outlined, color: Colors.white70, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  _timerLabel,
                                  style: TextStyle(
                                    color: _timerColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.difficulty.label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),

                const Spacer(),

                // card grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _config.crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: _config.childAspectRatio,
                    ),
                    itemBuilder: (_, i) => _buildCard(i),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final card = _cards[index];
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedBuilder(
        animation: _flipAnimations[index],
        builder: (_, __) {
          final angle = _flipAnimations[index].value * pi;
          final isFront = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _CardFace(color: card.color, isMatched: card.isMatched),
                  )
                : const _CardBack(),
          );
        },
      ),
    );
  }

// end screen
  Widget _buildEndScreen() {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_gameWon ? '🎉' : '⏰', style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  _gameWon ? 'You matched them all!' : 'Time\'s up!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                if (!_gameWon)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Better luck next time',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
                    ),
                  ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF388E3C),
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// card face
class _CardFace extends StatelessWidget {
  final Color color;
  final bool isMatched;
  const _CardFace({required this.color, required this.isMatched});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: isMatched
            ? Border.all(color: Colors.white, width: 3)
            : Border.all(color: Colors.white24, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: isMatched ? 18 : 8,
            spreadRadius: isMatched ? 3 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMatched
          ? const Center(child: Icon(Icons.check_rounded, color: Colors.white, size: 36))
          : null,
    );
  }
}


// back of card 
class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Icon(Icons.question_mark_rounded, color: Colors.white.withOpacity(0.25), size: 32),
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