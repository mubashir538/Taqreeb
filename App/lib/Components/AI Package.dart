import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class AIPackage extends StatelessWidget {
  final String price, events, cateringCost, venueCost, photographer;
  final Function onpressed;
  const AIPackage(
      {super.key,
      required this.onpressed,
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
        fontSize: MaximumThing * 0.015,
        fontWeight: FontWeight.w400,
        color: MyColors.white);
    TextStyle body = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.015,
        fontWeight: FontWeight.w300,
        color: MyColors.white);

    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.35,
      margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
      padding: EdgeInsets.all(MaximumThing * 0.02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(2, 2))
          ],
          color: MyColors.DarkLighter),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price',
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.026,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white)),
              Text(price,
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.026,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white)),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Catering Cost', style: heading),
              Text(
                cateringCost,
                style: body,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Venue Cost', style: heading),
              Text(
                venueCost,
                style: body,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ColoredButton(
                text: 'See Details',
                width: screenWidth * 0.4,
                onPressed: () => onpressed(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
