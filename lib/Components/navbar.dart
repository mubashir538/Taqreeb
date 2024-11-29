import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    double size = maximumThing * 0.025;

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
            InkWell(
              child: SvgPicture.asset(MyIcons.home,
                  width: size,
                  height: size,
                  color:
                      widget.selectedIndex == 0 ? Colors.yellow : Colors.white),
              onTap: () {
                _onItemTapped(0);
                // Navigator.pushNamed(context, '/HomePage');
              },
            ),
            InkWell(
              onTap: () {
                _onItemTapped(1);
                // Navigator.pushNamed(context, '/ChatsScreen');
              },
              child: SvgPicture.asset(MyIcons.chats,
                  width: size,
                  height: size,
                  color:
                      widget.selectedIndex == 1 ? Colors.yellow : Colors.white),
            ),
            SizedBox(width: screenWidth * 0.05),
            InkWell(
              child: SvgPicture.asset(MyIcons.events,
                  width: size,
                  height: size,
                  color:
                      widget.selectedIndex == 2 ? Colors.yellow : Colors.white),
              onTap: () {
                _onItemTapped(2);
                // Navigator.pushNamed(context, '/YourEvents');
              },
            ),
            InkWell(
                child: SvgPicture.asset(MyIcons.profile,
                    width: size,
                    height: size,
                    color: widget.selectedIndex == 3
                        ? Colors.yellow
                        : Colors.white),
                onTap: () {
                  _onItemTapped(3);
                  // Navigator.pushNamed(context, '/AccountInfo');
                }),
          ],
        ),
      ),
    );
  }
}
