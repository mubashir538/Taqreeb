import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Cart%20Item.dart';
import 'package:taqreeb/Components/Checklist%20Items%20Adder.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
<<<<<<< Updated upstream
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
=======
import 'package:taqreeb/Components/Event%20Function.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
>>>>>>> Stashed changes

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff18191A),
<<<<<<< Updated upstream
      // appBar: AppBar(title: const Text('Taqreeb')),
      body: Column(
        children: [
          Header(),
          Function1(),
          ColoredButton(text: 'Hello')
        ],
      ),
=======
      appBar: AppBar(title: const Text('Taqreeb')),
      // body: ColoredButton(text: 'Continue'),
      // body: BorderButton(text: 'Signup'),
      body: EventFuntion(),
>>>>>>> Stashed changes
    );
  }
}
