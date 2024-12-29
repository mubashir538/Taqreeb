import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SlidingRow extends StatelessWidget {
  final String title; // Title of the row
  final List<String> images; // List of image URLs

  const SlidingRow({required this.title, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and "See All" row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.Yellow,
                ),
              ),
              Text(
                "see all",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Scrollable Row with Scrollbar
          SizedBox(
            height: screenWidth * 0.4, // Height for the sliding row
            child: Scrollbar(
              thumbVisibility: true, // Always show the scrollbar thumb
              radius: const Radius.circular(8.0), // Rounded scrollbar
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      child: Image.network(
                        images[index],
                        width: screenWidth * 0.3, // Width of each image
                        height: screenWidth * 0.4, // Height of each image
                        fit: BoxFit.cover, // Scale the image
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
