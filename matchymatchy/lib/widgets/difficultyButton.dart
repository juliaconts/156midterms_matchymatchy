import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// difficulty button
class DifficultyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DifficultyButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color.fromARGB(255, 88, 32, 32),
          elevation: 6,
          shadowColor: const Color.fromARGB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.indieFlower(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}