import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SendMessage extends StatelessWidget {
  final String text;
  final String time;
  SendMessage({required this.text, required this.time});

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
          Text(
            time,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: MaximumThing * 0.017,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: MyColors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: MyColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
