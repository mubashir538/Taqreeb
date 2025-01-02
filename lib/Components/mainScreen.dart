import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Screens/AccountInfo.dart';
import 'package:taqreeb/Screens/BusinessAccountInfo.dart';
import 'package:taqreeb/Screens/ChatsScreen.dart';
import 'package:taqreeb/Screens/Dashboard.dart';
import 'package:taqreeb/Screens/HomePage.dart';
import 'package:taqreeb/Screens/YourEvents.dart';
import 'package:taqreeb/Screens/YourListings.dart';
import 'package:taqreeb/theme/color.dart';

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

  bool isLoading = true; 
  bool isBusinessOwner = false; 
  bool isFreelancer = false;
  @override
  void initState() {
    super.initState();

    fetchUser(); 
  }

  void fetchUser() async {
    final utype = await MyStorage.exists(MyTokens.isBusinessOwner);
    final ftype = await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      isBusinessOwner = utype;
      isFreelancer = ftype;
      isLoading = false; 
    });
  }

  void updateValue(int newValue) {
    setState(() {
      widget.index = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardVisible = keyboard > 0;
    List<Widget> currentPageList =
        isBusinessOwner || isFreelancer ? businessPages : pages;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), 
            )
          : currentPageList[widget.index], 
      
      floatingActionButton:isKeyboardVisible? null: SizedBox(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                isBusinessOwner || isFreelancer
                    ? '/AddCategory_List'
                    : '/CreateEvent'); 
          },
          backgroundColor: MyColors.Yellow,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            size: maximumThing * 0.04,
            color: MyColors.Dark,
          ),
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
