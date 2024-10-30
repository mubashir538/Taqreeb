import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/colors/color.dart';

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  const TextBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centers the TextBox by default
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xffEDF2F4), // Text color
            ),
            decoration: InputDecoration(
              hintText: 'First Name', // This will show as a placeholder
              hintStyle: GoogleFonts.montserrat(
                color: MyColors.white.withOpacity(0.6), // Hint text color
                fontSize: 18,
              ),
              border: InputBorder.none, // Remove the default border
            ),
          ),
        ),
      ),
    );
  }
}
