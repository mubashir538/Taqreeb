import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final VoidCallback? onclick;
  final String hint;
  final Function(String) onChanged;
  const SearchBox(
      {super.key,
      required this.onChanged,
      required this.hint,
      required this.controller,
      this.width = 0,
      this.onclick});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: onclick,
      child: Container(
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
                width: screenWidth * 0.5,
                child: GestureDetector(
                  onTap: onclick,
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.015,
                        color: MyColors.whiteDarker,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
