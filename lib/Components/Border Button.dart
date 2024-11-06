import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class BorderButton extends StatelessWidget {
  final String text;
  const BorderButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
      height: screenHeight * 0.06,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.red, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.montserrat(
              fontSize: MaximumThing * 0.018,
              fontWeight: FontWeight.w400,
              color: MyColors.red),
        ),
      ),
    );
  }
}
