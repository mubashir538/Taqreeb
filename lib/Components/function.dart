import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taqreeb/theme/color.dart';

class Function12 extends StatelessWidget {
  final String name, head, budget;
  final List<String> headings;
  final List<String> values;
  final String type;
  final Function editPressed;
  final Function seePressed;
  final Color color;
  final VoidCallback? delete;

  const Function12(
      {super.key,
      required this.delete,
      required this.color,
      required this.type,
      required this.headings,
      required this.values,
      required this.name,
      required this.head,
      required this.budget,
      required this.editPressed,
      required this.seePressed});

  bool isColorDark(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance < 0.5; // Dark color if luminance is less than 0.5
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: MaximumThing * 0.02),
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: MyColors.DarkLighter,
        ),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.07,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MaximumThing * 0.03,
                  ),
                  Center(
                    child: Text(
                      name,
                      style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.02,
                          fontWeight: FontWeight.w600,
                          color: isColorDark(color)? Color(0xffedf2f4): Color(0xff18191A)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: MaximumThing * 0.03,
                      color: isColorDark(color)? Color(0xffedf2f4): Color(0xff18191A),
                    ),
                    onPressed: delete,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.03),
              width: screenWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: MaximumThing * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          head,
                          style: GoogleFonts.montserrat(
                              fontSize: MaximumThing * 0.02,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white),
                        ),
                        Text(
                          budget,
                          style: GoogleFonts.montserrat(
                              fontSize: MaximumThing * 0.02,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white),
                        ),
                      ],
                    ),
                  ),
                  for (var items in headings)
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: MaximumThing * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items,
                            style: GoogleFonts.montserrat(
                                fontSize: MaximumThing * 0.015,
                                fontWeight: FontWeight.w300,
                                color: MyColors.white),
                          ),
                          Text(
                            values[headings.indexOf(items)],
                            style: GoogleFonts.montserrat(
                                fontSize: MaximumThing * 0.015,
                                fontWeight: FontWeight.w300,
                                color: MyColors.white),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(top: MaximumThing * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColoredButton(
                          text: 'Edit $type',
                          width: screenWidth * 0.38,
                          textSize: MaximumThing * 0.015,
                          onPressed: () {
                            editPressed();
                          },
                        ),
                        ColoredButton(
                          text: 'See Details',
                          width: screenWidth * 0.38,
                          textSize: MaximumThing * 0.015,
                          onPressed: () {
                            seePressed();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
