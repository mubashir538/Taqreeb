import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/faq_questions.dart';
import 'package:taqreeb/Components/Guide_icon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [
          GuideIcon(
            iconPath: 'assets/icons/stadium.png', 
            text: 'Venue Selection', 
          ),
        ],
      ),
    );
  }
}
