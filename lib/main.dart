import 'package:flutter/material.dart';
import 'package:taqreeb/OTP%20Screen.dart';
import 'package:taqreeb/BusinessSignup1.dart';
import 'Screens/Home/Home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusinessSignup1(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
