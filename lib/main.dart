import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Create%20guest%20list.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Login%20Screen.dart';
import 'package:taqreeb/Screens/splash%20screen.dart';

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
