import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:taqreeb/Screens/Home/Home.dart';
=======
import 'package:taqreeb/Screens/Event%20Details.dart';
>>>>>>> Stashed changes
import 'package:taqreeb/Screens/Login%20Screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
      home: Home(),
=======
      home: LoginScreen(),
>>>>>>> Stashed changes
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
