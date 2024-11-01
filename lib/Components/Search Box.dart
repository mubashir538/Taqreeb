import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  SearchBox({required this.controller});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          borderRadius: BorderRadius.circular(30), // Oval borders
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: controller,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  Colors.black, // Set text color to black for better contrast
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Start typing your search",
              hintStyle: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.black
                    .withOpacity(0.6), // Set hint text color to dark
              ),
            ),
          ),
        ),
      ),
    );
  }
}
