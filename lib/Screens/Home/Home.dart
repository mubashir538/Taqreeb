import 'package:flutter/material.dart';
import 'package:taqreeb/Components/text_box.dart';

class Home extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your First Name'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Matches the background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            TextBox(controller: firstNameController), // Your TextBox component
      ),
    );
  }
}
