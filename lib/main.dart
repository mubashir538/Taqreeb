import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/ChatBox.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Login%20Screen.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20Function%20Details.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20Package%20Details.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20suggested%20packages.dart';
import 'package:taqreeb/Screens/splash%20screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatBox(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
