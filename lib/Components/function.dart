import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taqreeb/theme/color.dart';

class Function12 extends StatelessWidget {
  const Function12({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
        height: screenHeight * 0.35,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),

          color: MyColors.DarkLighter,
        ),
        child: Column(
          children: [
            Container(

              height: screenHeight * 0.1,
              width: screenWidth * 0.9,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: MyColors.red,
              ),
              child: Center(
                child: Text(
                  "Mehndi ",
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w500,
                      color: MyColors.white),
                ),
              ),
            ),
       
            Container(
              height: screenHeight*0.25,
              width: screenWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Budget: ",
                          style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: MyColors.white),
                        ),
                        Text(
                          "10000000 ",
                          style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffEDF2F4)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ",
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,

                            color: MyColors.white),
               ),
                      Text(
                        "15-dec-24 ",
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: MyColors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColoredButton(
                        text: 'Edit Function',
                        height: 43,
                        width: 157,
                      ),
                      ColoredButton(
                        text: 'See Details',
                        height: 43,
                        width: 157,
                      ),
                      // ColoredButton(text: '')
                    ],
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
