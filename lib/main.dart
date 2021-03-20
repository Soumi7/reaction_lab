import 'package:flutter/material.dart';
import 'package:reaction_lab/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaca',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Raleway',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
