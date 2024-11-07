import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class OTPBoxes extends StatelessWidget {
  const OTPBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.07,
            width: screenHeight * 0.07,
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Container(
            height: screenHeight * 0.07,
            width: screenHeight * 0.07,
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Container(
            height: screenHeight * 0.07,
            width: screenHeight * 0.07,
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Container(
            height: screenHeight * 0.07,
            width: screenHeight * 0.07,
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
