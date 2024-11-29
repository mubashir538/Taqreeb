import 'package:flutter/material.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Screens/AccountInfo.dart';
import 'package:taqreeb/Screens/ChatsScreen.dart';
import 'package:taqreeb/Screens/HomePage.dart';
import 'package:taqreeb/Screens/YourEvents.dart';
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  MainScreen({super.key, this.index = 0});
  int index;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pages = [HomePage(), ChatsScreen(), YourEvents(), AccountInfo()];
  void updateValue(int newValue) {
    setState(() {
      widget.index = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      body: pages[widget.index],
      floatingActionButton: SizedBox(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/CreateEvent');
          },
          backgroundColor: MyColors.Yellow,
          child:
              Icon(Icons.add, size: MaximumThing * 0.04, color: MyColors.Dark),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(
        selectedIndex: widget.index,
        onValueChanged: updateValue,
      ),
    );
  }
}
