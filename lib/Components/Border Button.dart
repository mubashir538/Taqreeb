import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorderButton extends StatelessWidget {
  final String text;
  BorderButton({required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;

    return Center(
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.transparent, // Transparent background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            // Border property for the outline
            color: Color(0xffEF233c), // Border color
            width: 2, // Border thickness
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xffEF233c), // Text color matching border
            ),
          ),
        ),
      ),
    );
  }
}
