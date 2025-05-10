import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/utils/color.dart';

class FunctionCard extends StatelessWidget {
  final String name, head, budget;
  final List<String> headings;
  final List<String> values;
  final String type;
  final Function editPressed;
  final Function seePressed;
  final Color color;
  final VoidCallback? delete;

  const FunctionCard(
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
    double red = color.r;
    double green = color.g;
    double blue = color.b;

    double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance < 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: Screen.max(context) * 0.02),
        width: Screen.width(context) * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: MyColors.darkLighter,
        ),
        child: Column(
          children: [
            Container(
              height: Screen.height(context) * 0.07,
              width: Screen.width(context) * 0.9,
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
                    width: Screen.max(context) * 0.03,
                  ),
                  Center(
                    child: Text(
                      name,
                      style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.02,
                          fontWeight: FontWeight.w600,
                          color: isColorDark(color)
                              ? Color(0xffedf2f4)
                              : Color(0xff18191A)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: Screen.max(context) * 0.03,
                      color: isColorDark(color)
                          ? Color(0xffedf2f4)
                          : Color(0xff18191A),
                    ),
                    onPressed: delete,
                  )
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: Screen.max(context) * 0.03),
              width: Screen.width(context) * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: Screen.max(context) * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          head,
                          style: GoogleFonts.roboto(
                              fontSize: Screen.max(context) * 0.02,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white),
                        ),
                        Text(
                          budget,
                          style: GoogleFonts.roboto(
                              fontSize: Screen.max(context) * 0.02,
                              fontWeight: FontWeight.w500,
                              color: MyColors.white),
                        ),
                      ],
                    ),
                  ),
                  for (var items in headings)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: Screen.max(context) * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items,
                            style: GoogleFonts.roboto(
                                fontSize: Screen.max(context) * 0.015,
                                fontWeight: FontWeight.w300,
                                color: MyColors.white),
                          ),
                          Text(
                            values[headings.indexOf(items)],
                            style: GoogleFonts.roboto(
                                fontSize: Screen.max(context) * 0.015,
                                fontWeight: FontWeight.w300,
                                color: MyColors.white),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(top: Screen.max(context) * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColoredButton(
                          text: type.toLowerCase() == 'event'
                              ? 'Edit Event'
                              : 'Edit Function',
                          width: Screen.width(context) * 0.38,
                          textSize: Screen.max(context) * 0.015,
                          onPressed: () {
                            editPressed();
                          },
                        ),
                        ColoredButton(
                          text: 'See Details',
                          width: Screen.width(context) * 0.38,
                          textSize: Screen.max(context) * 0.015,
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
