import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class MessageChatButton extends StatelessWidget {
  final String name;
  final String message;
  final String time;

  const MessageChatButton({
    required this.name,
    required this.message,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: MaximumThing * 0.02, vertical: MaximumThing * 0.02),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Avatar Icon isme bs icon h image lgani hai
          Container(
            margin: EdgeInsets.only(right: MaximumThing * 0.03),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: MyColors.red,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.02,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.015,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MaximumThing * 0.01),
              Text(
                message,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
