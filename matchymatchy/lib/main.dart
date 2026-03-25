import 'package:flutter/material.dart';
import 'package:matchymatchy/services/audio_manager.dart';
import 'screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
