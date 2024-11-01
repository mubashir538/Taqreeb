import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class RecieveMessage extends StatelessWidget {
  final String text;
  final String time;
  RecieveMessage({required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.only(bottom: MaximumThing * 0.01),
      width: screenWidth * 0.9,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(MaximumThing * 0.01),
            decoration: BoxDecoration(
              color: MyColors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), // Left side more oval-like
                bottomLeft: Radius.circular(15), // Left side more oval-like
                topRight: Radius.circular(30), // Right side slightly curved
                bottomRight: Radius.circular(30), // Right side slightly curved
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.025,
                  fontWeight: FontWeight.w200,
                  color: MyColors.white,
                ),
              ),
            ),
          ),
          Text(
            time,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: MaximumThing * 0.017,
            ),
          )
        ],
      ),
    );
  }
}
