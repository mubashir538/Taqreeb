
import 'package:flutter/material.dart';

void main() {
  runApp(Abc());
}

class Abc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Centered Paragraph')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'This is a centered paragraph in Flutter. You can add more text here, and it will remain centered within the container.',
              textAlign: TextAlign.center, // Center the text
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}