import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taqreeb/theme/color.dart';

class Function12 extends StatelessWidget {
  const Function12({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 290,
        width: 373,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: MyColors.DarkLighter,
        ),
        child: Column(
          children: [
            Container(
              height: 76,
              width: 373,
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
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffEDF2F4)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Budget: ",
                        style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffEDF2F4)),
                      ),
                      SizedBox(
                        width: 70,
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Date: ",
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffEDF2F4)),
                      ),
                      SizedBox(
                        width: 135,
                      ),
                      Text(
                        "15-dec-24 ",
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffEDF2F4)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      ColoredButton(
                        text: 'Edit Function',
                        height: 43,
                        width: 157,
                      ),
                      SizedBox(
                        width: 20,
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
