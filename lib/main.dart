import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Screens/Create%20function.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Service%20View%20Page.dart';
import 'package:taqreeb/Screens/cartitem.dart';
// import 'package:taqreeb/Components/Cart%20Item.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartItem(),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
