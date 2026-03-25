import 'package:flutter/material.dart';

// app background of every screen
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 75, 47), 
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
        color: const Color.fromARGB(255, 58, 2, 2).withOpacity(opacity),
      ),
    );
  }
}