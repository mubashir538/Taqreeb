import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/colors/color.dart';


class ColoredButton extends StatelessWidget {
  final String text;
  const ColoredButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    print(width);

    return Center(
      child: Container(
          height: 60,
          width: 400,
          decoration: BoxDecoration(
              color: MyColors.red,
              // color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(text,
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(
                        0xffEDF2F4,
                      ))))),
    );
  }
}
