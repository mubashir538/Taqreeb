import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  const SearchBox({super.key, required this.controller, this.width = 0});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      height: screenHeight * 0.07,
      width: width == 0 ? screenWidth * 0.8 : width,
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.search, color: MyColors.white),
            Container(
              margin: EdgeInsets.only(left: MaximumThing * 0.02),
              width: screenWidth * 0.6,
              child: TextField(
                controller: controller,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.015,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Start typing your search",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.015,
                    color: MyColors.whiteDarker,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
