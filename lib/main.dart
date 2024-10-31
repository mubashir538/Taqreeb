import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/sign_up_screen.dart';
import 'package:taqreeb/OTP%20Screen.dart';
import 'package:taqreeb/Profile%20Screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
