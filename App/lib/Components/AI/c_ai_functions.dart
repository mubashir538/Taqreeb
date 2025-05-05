import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class AIFunctions extends StatelessWidget {
  final String event, date, price;
  final Function onpressed;
  const AIFunctions(
      {super.key,
      required this.onpressed,
      required this.event,
      required this.date,
      required this.price});

  @override
  Widget build(BuildContext context) {
    TextStyle heading = GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.02,
        fontWeight: FontWeight.w500,
        color: MyColors.white);
    TextStyle body = GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.02,
        fontWeight: FontWeight.w400,
        color: MyColors.white);

    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        width: Screen.width(context) * 0.9,
        height: Screen.height(context) * 0.2,
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: MyColors.darkLighter),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date', style: heading),
                Text(
                  date,
                  style: body,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }
}
