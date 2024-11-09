import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/AccountInfo1.dart';
import 'package:taqreeb/Screens/AccountInfo2.dart';
import 'package:taqreeb/Screens/Decorators.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Decorators(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
