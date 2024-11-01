import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryIcon extends StatelessWidget {
  final String label;

  const CategoryIcon({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    // Define the image URL directly in the component
    const String imageUrl = 'https://via.placeholder.com/150';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 10), // Space between image and text
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Customize as per your design
          ),
        ),
      ],
    );
  }
}
