import 'package:flutter/material.dart';

// front face of the card
class CardFace extends StatelessWidget {
  final String imagePath;
  final bool isMatched;

  const CardFace({
    super.key,
    required this.imagePath,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isMatched
            ? Border.all(color: Colors.white, width: 3)
            : Border.all(color: Colors.white24, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: isMatched ? 18 : 8,
            spreadRadius: isMatched ? 3 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            if (isMatched)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 36),
                ),
              ),
          ],
        ),
      ),
    );
  }
}