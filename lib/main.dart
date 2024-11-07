import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cake%20Box.dart';
import 'package:taqreeb/Screens/Create%20function.dart';
import 'package:taqreeb/Screens/Home/Home.dart';
import 'package:taqreeb/Screens/Home/bakery%20and%20sweets.dart';
import 'package:taqreeb/Screens/Service%20View%20Page.dart';
// import 'package:taqreeb/Components/Cart%20Item.dart';

// import 'package:taqreeb/Screens/Create%20guest%20list/creategueslist2.dart';
// import 'package:taqreeb/Screens/Create%20guest%20list/creategueslist3.dart';
// import 'package:taqreeb/Screens/Home/Home.dart';
// import 'package:taqreeb/Screens/Login%20Screen.dart';
import 'package:taqreeb/Screens/cartitem.dart';
// import 'package:taqreeb/Screens/splash%20screen.dart';

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
