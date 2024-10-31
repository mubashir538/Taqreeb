import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return BottomAppBar(
      color: Colors.redAccent,
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: SvgPicture.asset(MyIcons.home,
                color: _selectedIndex == 0 ? Colors.yellow : Colors.white),
            onTap: () => _onItemTapped(0),
          ),

          InkWell(
            onTap: () => _onItemTapped(1),
            child: SvgPicture.asset(MyIcons.chats,
                color: _selectedIndex == 1 ? Colors.yellow : Colors.white),
          ),
          SizedBox(width: 48.0), // space for the floating action button
          InkWell(
            child: SvgPicture.asset(MyIcons.events,
                color: _selectedIndex == 2 ? Colors.yellow : Colors.white),
            onTap: () => _onItemTapped(2),
          ),
          InkWell(
            child: SvgPicture.asset(MyIcons.profile,
                color: _selectedIndex == 3 ? Colors.yellow : Colors.white),
            onTap: () => _onItemTapped(3),
          ),
        ],
      ),
    );
  }
}
