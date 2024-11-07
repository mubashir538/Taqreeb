import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/navbar.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              heading: 'Your Events',
            ),
            SizedBox(height: screenHeight * 0.02),
            Function12(),
            SizedBox(height: screenHeight * 0.02),
            Function12(),
            Navbar()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.red),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
