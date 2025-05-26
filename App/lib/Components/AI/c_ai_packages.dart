import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    final colors = AppColors(context);
    TextStyle heading = GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.015,
        fontWeight: FontWeight.w400,
        color: colors.white);
    TextStyle body = GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.015,
        fontWeight: FontWeight.w300,
        color: colors.white);

    return Container(
      width: Screen.width(context) * 0.8,
      height: Screen.height(context) * 0.35,
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(127),
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(2, 2))
          ],
          color: colors.darkLighter),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price',
                  style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.026,
                      fontWeight: FontWeight.w600,
                      color: colors.white)),
              Text(price,
                  style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.026,
                      fontWeight: FontWeight.w600,
                      color: colors.white)),
            ],
          ),
          SizedBox(
            height: Screen.height(context) * 0.01,
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
          SizedBox(height: Screen.height(context) * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ColoredButton(
                text: 'See Details',
                width: Screen.width(context) * 0.4,
                onPressed: () => onpressed(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
