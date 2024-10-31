import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class AIFunctions extends StatelessWidget {
  final String event,date,price;
  const AIFunctions({super.key,required this.event,required this.date,required this.price});

  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextStyle heading = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.02,
        fontWeight: FontWeight.w500,
        color: Colors.white);
    TextStyle body = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.02,
        fontWeight: FontWeight.w400,
        color: Colors.white);

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: MyColors.DarkLighter),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Event',
                style: heading,
              ),
              Text(
                event,
                style: body,
              )
            ],
          ),
          Row(
            children: [
              Text('Date', style: heading),
              Text(
                date,
                style: body,
              )
            ],
          ),
          Row(
            children: [
              Text('Price', style: heading),
              Text(
                price,
                style: body,
              )
            ],
          ),
        
        ],
      ),
    );
;
  }
}