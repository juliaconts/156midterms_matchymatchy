import 'package:flutter/material.dart';

mixin ScreenAnimationMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController animController;
  late Animation<double> fadeIn;
  late Animation<Offset> slideUp;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    fadeIn = CurvedAnimation(
      parent: animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    slideUp = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: animController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  Widget fadeSlide({required Widget child}) {
    return SlideTransition(
      position: slideUp,
      child: FadeTransition(opacity: fadeIn, child: child),
    );
  }

  Widget fadeOnly({required Widget child}) {
    return FadeTransition(opacity: fadeIn, child: child);
  }
}