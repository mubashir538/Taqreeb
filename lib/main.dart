import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taqreeb/Screens/homepage.dart';
//import 'package:taqreeb/Screens/signup1.dart';
//import 'package:taqreeb/Screens/signup2.dart';
//import 'package:taqreeb/Screens/signup3.dart';
//import 'package:taqreeb/Screens/signup4.dart';
//import 'package:taqreeb/Screens/signup5.dart';
//import 'package:taqreeb/Screens/signup6.dart';
//import 'package:taqreeb/Screens/yourevent.dart';
//import 'package:taqreeb/Screens/createevent.dart';
//import 'package:taqreeb/Screens/homepage.dart';
import 'package:taqreeb/Screens/helpcenter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelpCenterScreen(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
