import 'dart:math';
import 'package:flutter/material.dart';
import '../config/difficultyConfig.dart';
import '../widgets/appBackground.dart';
import '../widgets/cardFace.dart';
import '../widgets/cardBack.dart';
import '../config/gamesScreenLogic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart'; 

// gamescreen widgets

mixin GameScreenWidgets<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T>, GameScreenLogic<T> {
  GameDifficulty get difficulty;
  late ConfettiController _confettiController; 

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 30));
  }

  @override
  void dispose() {
    _confettiController.dispose(); 
    super.dispose();
  }

  @override
void onGameWon() {
  _confettiController.play();
}

  Widget buildGameScreen() {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          Positioned(
            top: -60,
            right: -60,
            child: BackgroundCircle(size: 200, opacity: 0.10),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: BackgroundCircle(size: 260, opacity: 0.09),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 4),
                _buildDifficultyLabel(),
                const Spacer(),
                _buildCardGrid(),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEndScreen() {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                    Image.asset(
                    gameWon ? 'assets/gif/happycat.gif' : 'assets/gif/sadcat.gif' ,
                    height: 200.0,
                    width: 200.0,
                  ),
                const SizedBox(height: 10),
                const SizedBox(height: 16),
                Text(
                  gameWon ? 'You matched them all!' : 'Time\'s up!',
                  style: GoogleFonts.indieFlower(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                if (!gameWon) _buildLossSubtitle(),
                const SizedBox(height: 40),
                _buildBackButton(),
              ],
            ),
          ),
          if (gameWon) 
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
              confettiController: _confettiController, 
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.yellow],
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(child: Center(child: _buildTimerBadge())),
          _buildExitButton(),
        ],
      ),
    );
  }

  Widget _buildTimerBadge() {
    return Container(
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
            timerLabel,
            style: GoogleFonts.indieFlower(
              color: timerColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildDifficultyLabel() {
    return Text(
      difficulty.label,
      style: GoogleFonts.indieFlower(
        color: Colors.white.withOpacity(0.55),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildCardGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: config.crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: config.childAspectRatio,
        ),
        itemBuilder: (_, i) => _buildCard(i),
      ),
    );
  }

  Widget _buildCard(int index) {
    final card = cards[index];
    return GestureDetector(
      onTap: () => onCardTap(index),
      child: AnimatedBuilder(
        animation: flipAnimations[index],
        builder: (_, __) {
          final angle = flipAnimations[index].value * pi;
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
                    child: CardFace(
                      imagePath: card.imagePath,
                      isMatched: card.isMatched,
                    ),
                  )
                : const CardBack(),
          );
        },
      ),
    );
  }

  Widget _buildLossSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: 
         Text(
        'Better luck next time',
        style: GoogleFonts.indieFlower(
          color: Colors.white.withOpacity(0.7),
          fontSize:20,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        'back',
        style: GoogleFonts.indieFlower(
          color: Colors.white.withOpacity(0.75),
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}