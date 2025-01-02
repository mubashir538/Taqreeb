import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class Navbar extends StatefulWidget {
  Navbar(
      {super.key, required this.selectedIndex, required this.onValueChanged});
  int selectedIndex;
  final ValueChanged<int> onValueChanged;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      widget.onValueChanged(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    double iconSize = maximumThing * 0.025;
    double tapAreaSize = iconSize + 20; 

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      clipBehavior: Clip.hardEdge,
      child: BottomAppBar(
        height: screenHeight * 0.06,
        color: MyColors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(
              icon: MyIcons.home,
              index: 0,
              size: iconSize,
              tapAreaSize: tapAreaSize,
            ),
            _buildNavItem(
              icon: MyIcons.chats,
              index: 1,
              size: iconSize,
              tapAreaSize: tapAreaSize,
            ),
            SizedBox(width: screenWidth * 0.05),
            _buildNavItem(
              icon: MyIcons.events,
              index: 2,
              size: iconSize,
              tapAreaSize: tapAreaSize,
            ),
            _buildNavItem(
              icon: MyIcons.profile,
              index: 3,
              size: iconSize,
              tapAreaSize: tapAreaSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required int index,
    required double size,
    required double tapAreaSize,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: tapAreaSize,
        height: tapAreaSize,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          width: size,
          height: size,
          color: widget.selectedIndex == index ? Colors.yellow : Colors.white,
        ),
      ),
    );
  }
}
