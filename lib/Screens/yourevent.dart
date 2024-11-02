import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/Navbar.dart';

class EventsScreen extends StatelessWidget {
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
            Function1(), 
            SizedBox(height: screenHeight * 0.02), 
            Function1(), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.red),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(),
    );
  }
}
