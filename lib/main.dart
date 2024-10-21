import 'package:flutter/material.dart';
import 'Screens/Home/Home.dart';

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
