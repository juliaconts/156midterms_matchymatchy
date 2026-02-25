import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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
        children: [
        Text(
        'Matchy Matchy',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
            ),
           ),
           const SizedBox(height: 20),

           ElevatedButton(onPressed: (){

          Navigator.pop(context); 

          }, child: Text('Back'), style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.lightGreen,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),),
        ]
          ),
         );
        }
      ),
    );  
  }
}
