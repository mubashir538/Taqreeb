import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class CreateGuestList extends StatelessWidget {
  const CreateGuestList({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(
                heading: 'Create Guest List',
                image: MyImages.GuestList,
              ),

              // Container(
              //   height: screenHeight*0.07,
              //   width: screenWidth*0.9,
              //   decoration: BoxDecoration(
              //     color: MyColors.DarkLighter,
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(16),
              //       topRight: Radius.circular(16),
              //       bottomLeft: Radius.circular(16),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: 10,
              //       ),
              //       ColoredButton(
              //         text: "Add Person",
              //         height: 28,
              //         width: 115,
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       ColoredButton(
              //         text: "Add Family",
              //         height: 28,
              //         width: 115,
              //       )
              //     ],
              //   ),
              // ),
              // SizedBox(height: 5),

              Container(
                height: screenHeight * 0.07,
                width: screenWidth * 0.9,
                padding: EdgeInsets.symmetric(
                    vertical: MaximumThing * 0.02,
                    horizontal: MaximumThing * 0.03),
                decoration: BoxDecoration(
                  color: MyColors.DarkLighter,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create guest list",
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.015,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white,
                      ),
                    ),
                    Image.asset(
                      MyIcons.add,
                      color: MyColors.white,
                      height: MaximumThing * 0.06,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
