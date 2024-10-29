import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff18191A),
      // appBar: AppBar(title: const Text('Taqreeb')),
      body: Column(
        children: [
          Header(),
          Function1(),
          ColoredButton(text: 'Hello')
        ],
      ),
    );
  }
}
