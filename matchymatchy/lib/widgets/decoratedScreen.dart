import 'package:flutter/material.dart';
import '../widgets/appBackground.dart';

class DecoratedScreenScaffold extends StatelessWidget {
  final Widget child;

  const DecoratedScreenScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          Positioned(
            top: -60,
            right: -60,
            child: BackgroundCircle(size: 200, opacity: 0.12),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: BackgroundCircle(size: 130, opacity: 0.08),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: BackgroundCircle(size: 260, opacity: 0.10),
          ),
          Positioned(
            bottom: 130,
            right: -30,
            child: BackgroundCircle(size: 150, opacity: 0.09),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}