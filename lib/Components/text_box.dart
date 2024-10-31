import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class TextBox extends StatelessWidget {
  final String hint;
  const TextBox({super.key,required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 400,
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xffEDF2F4), // Text color
          ),
          decoration: InputDecoration(
            hintText: hint, // This will show as a placeholder
            hintStyle: GoogleFonts.montserrat(
              color: MyColors.white.withOpacity(0.6), // Hint text color
              fontSize: 18,
            ),
            border: InputBorder.none, // Remove the default border
          ),
        ),
      ),
    );
  }
}
