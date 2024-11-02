import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Event%20Details.dart';
import 'package:taqreeb/Screens/View%20Function.dart';

import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Login%20Screen.dart';

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
