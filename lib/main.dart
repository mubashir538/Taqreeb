import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/AccountInfo1.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountInfo1(),
      // routes: {
      //   '/': (context) => SignUpScreen(),
      // },
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
