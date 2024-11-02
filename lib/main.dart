import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Login%20Screen.dart';
import 'package:taqreeb/Screens/View%20Function.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
