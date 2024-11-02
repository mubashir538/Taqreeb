import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryIcon({super.key, required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
