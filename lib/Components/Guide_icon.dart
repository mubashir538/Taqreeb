import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class GuideIcon extends StatelessWidget {
  final IconData icon;

  // Setting a default value for text as "Venue Selection"
  const GuideIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 220, // Set height for the square box
        width: 200, // Set width for the square box
        decoration: BoxDecoration(
          color: MyColors
              .DarkLighter, // Background color (dark as per the reference)
          borderRadius: BorderRadius.circular(15), // Rounded border
          border: Border.all(color: Colors.grey), // Border color and width
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, // The icon passed from the constructor
              color:
                  Color(0xffEDF2F4), // Icon color (white as per the reference)
              size: 50, // Size of the icon
            ),
            SizedBox(height: 10), // Space between icon and text
            Text(
              'Venue Selection', // Default text is now "Venue Selection"
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(
                    0xffEDF2F4), // Text color (white as per the reference)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
