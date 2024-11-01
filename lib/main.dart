import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Create%20guest%20list.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Home/Screens%20chats.dart';
import 'package:taqreeb/Screens/Home/sign_up_screen.dart';
import 'package:taqreeb/Screens/Home/OTP%20Screen.dart';
import 'package:taqreeb/Screens/Home/Profile%20Screen.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateGuestList(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
