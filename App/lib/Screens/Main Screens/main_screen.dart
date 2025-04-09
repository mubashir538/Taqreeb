import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/dashboard.dart';
import 'package:taqreeb/Screens/chat/chats_screen.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/global/navbar.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_business.dart';
import 'package:taqreeb/Screens/Main%20Screens/User/home.dart';
import 'package:taqreeb/Screens/Main%20Screens/User/user_events.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/user_listings.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/utils/color.dart';

class MainScreen extends StatefulWidget {
  final int index;

  const MainScreen({super.key, this.index = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _pages;
  late List<Widget> _businessPages;
  bool _isLoading = true;
  bool _isBusinessOwner = false;
  bool _isFreelancer = false;
  int _currentIndex = 0; // Local state variable for managing the selected index
  final controller = YourListingsController();

  void initializeController() async {
    await controller.fetchData();
  }

  @override
  void initState() {
    super.initState();
    _initializePages();
    _fetchUser();
    _currentIndex = widget.index; // Initialize with the provided index
  }

  void _initializePages() {
    initializeController();
    _pages = [
      const HomePage(),
      const ChatsScreen(),
      const YourEvents(),
      const AccountInfo(),
    ];

    _businessPages = [
      const Dashboard(),
      const ChatsScreen(),
      YourListingsScreen(controller: controller),
      const BusinessAccountInfo(),
    ];
  }

  Future<void> _fetchUser() async {
    final isBusinessOwner = await MyStorage.exists(MyTokens.isBusinessOwner);
    final isFreelancer = await MyStorage.exists(MyTokens.isFreelancer);

    setState(() {
      _isBusinessOwner = isBusinessOwner;
      _isFreelancer = isFreelancer;
      _isLoading = false;
    });
  }

  void _updateIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex; // Update the local state variable
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final currentPageList =
        _isBusinessOwner || _isFreelancer ? _businessPages : _pages;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentPageList[_currentIndex], // Use the local state variable
      floatingActionButton: isKeyboardVisible
          ? null
          : FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  _isBusinessOwner || _isFreelancer
                      ? '/AddCategory_List'
                      : '/CreateEvent',
                );
              },
              backgroundColor: MyColors.Yellow,
              shape: const CircleBorder(),
              child: Icon(
                Icons.add,
                size: Screen.max(context) * 0.04,
                color: MyColors.Dark,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(
        selectedIndex: _currentIndex, // Use the local state variable
        onValueChanged: _updateIndex,
      ),
    );
  }
}
