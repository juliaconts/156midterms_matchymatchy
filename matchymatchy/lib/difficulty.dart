import 'package:flutter/material.dart';

import 'game.dart';

class Difficulty extends StatefulWidget {
  const Difficulty({super.key});

  @override
  State<Difficulty> createState() => _DifficultyState();
}

class _DifficultyState extends State<Difficulty> {
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

        Navigator.push(context, MaterialPageRoute(builder: (context) => Game()));

      }, child: Text('Easy'), style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightGreen,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),),
      ElevatedButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => Game()));

      }, child: Text('Medium'), style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightGreen,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),), 
      ElevatedButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context) => Game()));

      }, child: Text('Hard'), style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightGreen,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),),
        ElevatedButton(onPressed: (){

        Navigator.pop(context);

      }, child: Text('Back'), style: ElevatedButton.styleFrom(
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