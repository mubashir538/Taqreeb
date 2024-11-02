import 'package:flutter/material.dart';
//import 'package:taqreeb/Screens/homepage.dart';
//import 'package:taqreeb/Screens/helpcenter.dart';
//import 'package:taqreeb/Screens/customersupport.dart';
import 'package:taqreeb/Screens/helpcenter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SupportScreen(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
