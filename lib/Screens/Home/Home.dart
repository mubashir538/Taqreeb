import 'package:flutter/material.dart';
import 'package:taqreeb/Components/category_icon.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set a background color
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.black, // Customize AppBar color
      ),
      body: Center(
        child: CategoryIcon(
          label: 'Caterers',
        ),
      ),
    );
  }
}
