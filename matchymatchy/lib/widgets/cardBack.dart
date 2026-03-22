import 'package:flutter/material.dart';

// back of the card
class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset('assets/cards/back-card.png', fit: BoxFit.cover),
    );
  }
}