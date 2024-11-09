import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/creategueslist1.dart';
import 'package:taqreeb/Screens/Venue.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateGuestList1(),

      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
