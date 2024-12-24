import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Screens/AccountInfo.dart';
import 'package:taqreeb/Screens/BusinessAccountInfo.dart';
import 'package:taqreeb/Screens/ChatsScreen.dart';
import 'package:taqreeb/Screens/Dashboard.dart';
import 'package:taqreeb/Screens/HomePage.dart';
import 'package:taqreeb/Screens/YourEvents.dart';
import 'package:taqreeb/Screens/screens%20to%20be%20made/YourListings.dart';
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
  List<Widget> businessPages = [
    Dashboard(),
    ChatsScreen(),
    YourListings(),
    BusinessAccountInfo()
  ];
  void updateValue(int newValue) {
    setState(() {
      widget.index = newValue;
    });
  }

  bool userType = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    userType = await MyStorage.exists('isBusinessOwner');
  
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: bool.parse(userType.toString())
          ? businessPages[widget.index]
          : pages[widget.index],
      floatingActionButton: SizedBox(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/CreateEvent');
          },
          backgroundColor: MyColors.Yellow,
          shape: CircleBorder(),
          child:
              Icon(Icons.add, size: MaximumThing * 0.04, color: MyColors.Dark),
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
