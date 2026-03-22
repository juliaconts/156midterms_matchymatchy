import 'package:flutter/material.dart';

// app background of every screen
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// decorative circles.
class BackgroundCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const BackgroundCircle({
    super.key,
    required this.size,
    required this.opacity,
  });

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