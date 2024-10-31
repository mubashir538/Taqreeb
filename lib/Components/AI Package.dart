import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class AIPackage extends StatelessWidget {
  final String price, events, cateringCost, venueCost, photographer;
  const AIPackage(
      {super.key,
      required this.cateringCost,
      required this.venueCost,
      required this.price,
      required this.events,
      required this.photographer});

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
              Text('Price',
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Text(price,
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Text(
                'Events',
                style: heading,
              ),
              Text(
                events,
                style: body,
              )
            ],
          ),
          Row(
            children: [
              Text('Catering Cost', style: heading),
              Text(
                cateringCost,
                style: body,
              )
            ],
          ),
          Row(
            children: [
              Text('Venue Cost', style: heading),
              Text(
                venueCost,
                style: body,
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Photographer Included',
                style: heading,
              ),
              Text(
                photographer,
                style: body,
              )
            ],
          ),
          SizedBox(height: 10),
          ColoredButton(text: 'See Details')
        ],
      ),
    );
  }
}
