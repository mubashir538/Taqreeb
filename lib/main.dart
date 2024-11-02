import 'package:flutter/material.dart';
import 'package:taqreeb/BusinessSignup1.dart';
import 'package:taqreeb/Bussiness%20Signup2.dart';
import 'package:taqreeb/Screens/Event%20Details.dart';
import 'package:taqreeb/Screens/Business%20Signup3.dart';
import 'package:taqreeb/Screens/View%20Function.dart';
import 'package:taqreeb/Screens/sign_up_screen.dart';
import 'Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Home/Profile%20Screen.dart';
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
      home: ViewFunctionsScreen(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
