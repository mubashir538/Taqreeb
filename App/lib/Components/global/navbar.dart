import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';

// ignore: must_be_immutable
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
    double iconSize = Screen.max(context) * 0.025;
    double tapAreaSize = iconSize + 20;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      clipBehavior: Clip.hardEdge,
      child: BottomAppBar(
        height: Screen.height(context) * 0.06,
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
            SizedBox(width: Screen.width(context) * 0.05),
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
