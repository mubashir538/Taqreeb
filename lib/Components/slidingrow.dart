import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SlidingRow extends StatelessWidget {
  final String title; 
  final List<String> images; 

  const SlidingRow({required this.title, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          SizedBox(
            height: screenWidth * 0.4, 
            child: Scrollbar(
              thumbVisibility: true, 
              radius: const Radius.circular(8.0), 
              child: ListView.builder(
                scrollDirection: Axis.horizontal, 
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), 
                      child: Image.network(
                        images[index],
                        width: screenWidth * 0.3, 
                        height: screenWidth * 0.4,
                        fit: BoxFit.cover, 
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
