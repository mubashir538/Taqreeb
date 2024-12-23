import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class ColoredButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final double textSize;
  const ColoredButton(
      {required this.text,
      super.key,
      this.textSize = 0,
      this.height = 0,
      this.width = 0,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
        height: height != 0 ? height : screenHeight * 0.06,
        width: width != 0 ? width : screenWidth * 0.9,
        decoration: BoxDecoration(
            color: MyColors.red,
            // color: Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: textSize == 0 ? MaximumThing * 0.018 : textSize,
              fontWeight: FontWeight.w500,
              color: MyColors.redonWhite,
            ),
          ),
        ),
      ),
    );
  }
}
