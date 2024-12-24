import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AddcategoryAddons extends StatelessWidget {
  const AddcategoryAddons({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'AddOns',
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              margin: EdgeInsets.all(screenWidth * 0.01),
              height: screenHeight * 0.2,
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double rowSpacing = constraints.maxWidth * 0.02;
                  double textSizeLarge = constraints.maxWidth * 0.05;
                  double textSizeSmall = constraints.maxWidth * 0.04;
                  double priceAlignment = constraints.maxWidth * 0.5;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Add-Ons",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeLarge,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Decorations",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 30,000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Female Staff",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 20,000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Extra Staff",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 100/Person",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              margin: EdgeInsets.all(screenWidth * 0.01),
              height: screenHeight * 0.4,
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double rowSpacing = constraints.maxWidth * 0.02;
                  double textSizeLarge = constraints.maxWidth * 0.05;
                  double textSizeSmall = constraints.maxWidth * 0.04;
                  double priceAlignment = constraints.maxWidth * 0.5;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Add-Ons",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeLarge,
                              fontWeight: FontWeight.w600,
                              color: MyColors.Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Hair Cut & Hair Color  ",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs.   2,000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Hair Treatments",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 1000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Manicure & Pedicure ",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 1500",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Eyesbrows & Lashes",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 5000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Waxing",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs. 800",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Skin Care",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs.  5,000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Row(
                        children: [
                          SizedBox(width: rowSpacing),
                          Text(
                            "Makeup",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.Yellow,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Rs.  1,000",
                            style: GoogleFonts.montserrat(
                              fontSize: textSizeSmall,
                              fontWeight: FontWeight.w400,
                              color: MyColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: MyColors.white,
                  child: Image.asset(
                    MyIcons.add,
                    color: MyColors.DarkLighter,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
