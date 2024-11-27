import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/creategueslist1.dart';
import 'package:taqreeb/Screens/Decorators.dart';
import 'package:taqreeb/Screens/Salon%20And%20Spa.dart';
import 'package:taqreeb/Screens/Venue.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SalonAndSpa(),

      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
