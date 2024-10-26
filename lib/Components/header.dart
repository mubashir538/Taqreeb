import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

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

    return Container(
      height: hasSomething ? null : screenHeight * 0.09,
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 3),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left_outlined,
                  color: MyColors.white, size: 50),
              Text(
                'Taqreeb',
                style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white),
              ),
              Icon(Icons.settings, color: MyColors.white, size: 40),
            ],
          ),
          heading.isNotEmpty
              ? Column(children: [
                  SizedBox(height: 10),
                  Text(
                    heading,
                    style: GoogleFonts.montserrat(
                        fontSize: 33,
                        fontWeight: FontWeight.w700,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                      height: para.isNotEmpty || image.isNotEmpty ? 5 : 15),
                ])
              : Container(),
          para.isNotEmpty
              ? Column(children: [
                  SizedBox(height: 5),
                  Text(
                    para,
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white),
                  ),
                  SizedBox(height: image.isNotEmpty ? 5 : 15),
                ])
              : Container(),
          image.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: 10),
                    SvgPicture.asset(image),
                    SizedBox(height: 15),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
