import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';

class BusinessSignup3 extends StatelessWidget {
  const BusinessSignup3({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(
                    heading: "Create a Description",
                    para: 'Your Description Creates a Great Impact on the\n'
                        'customers and can help your get more clients '),
                Column(
                  children: [
                    MyTextBox(hint: 'Profile Username'),
                    MyTextBox(hint: 'Profile Name'),
                    Container(
                      margin: EdgeInsets.all(MaximumThing * 0.01),
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      padding: EdgeInsets.symmetric(
                          horizontal: MaximumThing * 0.03,
                          vertical: MaximumThing * 0.02),
                      decoration: BoxDecoration(
                        color: MyColors.DarkLighter,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(2, 2))
                        ],
                      ),
                      child: TextField(
                        maxLines: 10,
                        style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: MaximumThing * 0.018,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.018,
                            color: MyColors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: "Enter Description",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "1100 characters left",
                            style: GoogleFonts.montserrat(
                              color: MyColors.white,
                              fontSize: MaximumThing * 0.018,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                      child: MyDivider(),
                    ),
                    ColoredButton(text: "Signup")
                  ],
                )
              ]),
        ));
  }
}
