import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/colors/color.dart';

class VenueSelection extends StatelessWidget {
  final String text;
  final IconData icon;

  // Setting a default value for text
  const VenueSelection({
    super.key,
    this.text = 'Venue Selection', // Default text is now "Venue Selection"
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                icon,
                color: Color(0xffEDF2F4), // Icon color
                size: 24,
              ),
            ),
            SizedBox(width: 20), // Add a SizedBox to create a gap of 20 pixels
            Text(
              text, // The text to display (default is "Venue Selection")
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xffEDF2F4), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
