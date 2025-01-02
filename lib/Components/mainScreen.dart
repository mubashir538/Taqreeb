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
  // Define separate page lists for regular and business users
  List<Widget> pages = [HomePage(), ChatsScreen(), YourEvents(), AccountInfo()];
  List<Widget> businessPages = [
    Dashboard(),
    ChatsScreen(),
    YourListings(),
    BusinessAccountInfo()
  ];

  // State variables
  bool isLoading = true; // Track loading state
  bool isBusinessOwner = false; // Track user type
  bool isFreelancer = false;
  @override
  void initState() {
    super.initState();

    fetchUser(); // Fetch the user type on initialization
  }

  // Fetch user type from storage
  void fetchUser() async {
    final utype = await MyStorage.exists(MyTokens.isBusinessOwner);
    final ftype = await MyStorage.exists(MyTokens.isFreelancer);
    setState(() {
      isBusinessOwner = utype;
      isFreelancer = ftype;
      isLoading = false; // Loading complete
    });
  }

  // Update selected index for the navbar
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
    // Determine the page list based on the user type
    List<Widget> currentPageList =
        isBusinessOwner || isFreelancer ? businessPages : pages;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : currentPageList[widget.index], // Display the selected page
      
      floatingActionButton:isKeyboardVisible? null: SizedBox(
        width: screenWidth * 0.15,
        height: screenWidth * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                isBusinessOwner || isFreelancer
                    ? '/AddCategory_List'
                    : '/CreateEvent'); // Navigate based on user type
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
        onValueChanged: updateValue, // Handle navbar value change
      ),
    );
  }
}
