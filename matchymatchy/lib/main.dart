import 'package:flutter/material.dart';

import 'difficulty.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context){
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[Text(
        'Matchy Matchy',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => Difficulty()));

      }, child: Text('Play'), style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightGreen,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),)
           ]
          ),
         );
        }
      ),
    );      
  }
}