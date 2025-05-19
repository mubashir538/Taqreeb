import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        border: Border.all(color: MyColors.white.withAlpha(123), width: 0.5)
      ),
      clipBehavior: Clip.hardEdge,
      child: BottomAppBar(
        color: MyColors.darkLighter, // Let container color show through
        elevation: 0, // No shadow needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavItem(
                icon: MyIcons.home,
                index: 0,
                size: iconSize,
                tapAreaSize: tapAreaSize,
                label: 'Home'),
            _buildNavItem(
                icon: MyIcons.chats,
                index: 1,
                size: iconSize,
                tapAreaSize: tapAreaSize,
                label: 'Chats'),
            SizedBox(width: Screen.width(context) * 0.05),
            _buildNavItem(
                icon: MyIcons.events,
                index: 2,
                size: iconSize,
                tapAreaSize: tapAreaSize,
                label: 'Events'),
            _buildNavItem(
                icon: MyIcons.profile,
                index: 3,
                size: iconSize,
                tapAreaSize: tapAreaSize,
                label: 'Account'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required String icon,
      required int index,
      required double size,
      required double tapAreaSize,
      required String label}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: tapAreaSize,
        height: tapAreaSize,
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: size,
              height: size,
              color:
                  widget.selectedIndex == index ? MyColors.red : MyColors.white,
            ),
            SizedBox(
              height: Screen.max(context) * 0.005,
            ),
            Text(
              label,
              style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.01,
                  color: widget.selectedIndex == index
                      ? MyColors.red
                      : MyColors.white,
                  fontWeight: widget.selectedIndex == index
                      ? FontWeight.w700
                      : FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
