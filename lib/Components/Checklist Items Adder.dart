import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class ChecklistItemsAdder extends StatelessWidget {
  final String text;
  final bool add;
  const ChecklistItemsAdder({super.key, required this.text, this.add = false});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Center(
      child: Container(
          margin: EdgeInsets.all(MaximumThing * 0.01),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08, vertical: screenHeight * 0.01),
          height: screenHeight * 0.05,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: MyColors.whiteDarker,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text,
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.015,
                      fontWeight: FontWeight.w500,
                      color: MyColors.whiteDarker)),
              add
                  ? Icon(
                      Icons.add,
                      color: MyColors.whiteDarker,
                    )
                  : Container(),
            ],
          )),
    );
  }
}
