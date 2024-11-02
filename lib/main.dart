import 'package:flutter/material.dart';
//import 'package:taqreeb/Screens/faq_venue_selection.dart';
//import 'package:taqreeb/Screens/Home/Home.dart';
//import 'package:taqreeb/Components/faq_questions.dart';
//import 'package:taqreeb/Screens/homepage.dart';
//import 'package:taqreeb/Screens/helpcenter.dart';
//import 'package:taqreeb/Screens/customersupport.dart';
//import 'package:taqreeb/Screens/helpcenter.dart';
//import 'package:taqreeb/Screens/faq.dart';
import 'package:taqreeb/Screens/guidescreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< Updated upstream
      home: GuideScreen(),
=======
      home: SignUpScreen(),
>>>>>>> Stashed changes
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
