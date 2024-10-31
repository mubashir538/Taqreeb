import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
        width: double.infinity,
        height: screenHeight * 0.09,
        decoration: BoxDecoration(
            color: MyColors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: SvgPicture.asset(MyIcons.home)),
            Flexible(child: SvgPicture.asset(MyIcons.chats)),
            Flexible(child: SvgPicture.asset(MyIcons.events)),
            Flexible(child: SvgPicture.asset(MyIcons.profile)),
          ],
        ));
  }
}
