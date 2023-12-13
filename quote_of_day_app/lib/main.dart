import 'package:flutter/material.dart';
import 'package:quote_of_day_app/home_page_quote_app.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: 
            [
               Color.fromARGB(255, 136, 11, 158),
               Color.fromARGB(255, 193, 49, 218)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: HomePage(),
      ),
    );
  }
}