import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/AccountInfo1.dart';
import 'package:taqreeb/Screens/AccountInfo2.dart';
import 'package:taqreeb/Screens/Create%20Checklist.dart';
import 'package:taqreeb/Screens/Home/Home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateChecklist(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
