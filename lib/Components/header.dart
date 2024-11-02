import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class Header extends StatelessWidget {
  final String heading;
  final String para;
  final String image;
  const Header({this.heading = '', this.para = '', this.image = '', super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool hasSomething =
        heading.isNotEmpty || para.isNotEmpty || image.isNotEmpty;
    double MaximumThing;
    if (screenWidth > screenHeight) {
      MaximumThing = screenWidth;
    } else {
      MaximumThing = screenHeight;
    }
    return Container(
      height: hasSomething ? null : screenHeight * 0.009,
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: MyColors.red,
        borderRadius: hasSomething
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            : BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chevron_left_outlined,
                    color: MyColors.white, size: MaximumThing * 0.03),
                Text(
                  'Taqreeb',
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.03,
                      fontWeight: FontWeight.w500,
                      color: MyColors.white),
                ),
                Icon(Icons.settings,
                    color: MyColors.white, size: MaximumThing * 0.03),
              ],
            ),
          ),
          heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    heading,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.025,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: para.isNotEmpty || image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    para,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.013,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(
                      height: image.isNotEmpty
                          ? screenHeight * 0.01
                          : screenHeight * 0.03),
                ])
              : Container(),
          image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    
                    SvgPicture.asset(image, height: screenHeight * 0.2),
                    SizedBox(height: screenHeight* 0.03),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
