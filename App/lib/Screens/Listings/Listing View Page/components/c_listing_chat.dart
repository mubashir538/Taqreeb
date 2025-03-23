import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';


class ChatIcon extends StatelessWidget {
  const ChatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double max = screenWidth > screenHeight ? screenWidth : screenHeight;
    return Positioned(
      bottom: screenHeight * 0.05,
      right: screenHeight * 0.03,
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(max * 0.017),
        child: Row(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              child: FaIcon(FontAwesomeIcons.comment,
                  color: Colors.white, size: max * 0.03),
            ),
            SizedBox(
              width: max * 0.01,
            ),
            Text(
              'Chat',
              style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: max * 0.015,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
