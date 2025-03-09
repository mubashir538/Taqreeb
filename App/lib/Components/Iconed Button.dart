import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class IconedButton extends StatelessWidget {
  final String text;
  final String icon;

  const IconedButton({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Center(
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.9,
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            SvgPicture.asset(icon,height: MaximumThing*0.03),
            SizedBox(width: MaximumThing*0.02,),
            Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: MaximumThing*0.015,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
                      ),
          ]
        ),
      ),
    );
  }
}
