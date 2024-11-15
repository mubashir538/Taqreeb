import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class RecieveMessage extends StatelessWidget {
  final String text;
  final String time;
  const RecieveMessage({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
      margin: EdgeInsets.only(bottom: MaximumThing * 0.02),
      width: screenWidth * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
            padding: EdgeInsets.all(MaximumThing * 0.02),
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              text,
              softWrap: true,
              textAlign: TextAlign.start,
              style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.015,
                fontWeight: FontWeight.w400,
                color: MyColors.white,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            time,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: MaximumThing * 0.013,
            ),
          )
        ],
      ),
    );
  }
}
