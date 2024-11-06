import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageProducts extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  final String price;

  const HomePageProducts({
    required this.image,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenHeight > screenWidth ? screenHeight : screenWidth;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              width: double.infinity,
              height: screenHeight * 0.2,
              fit: BoxFit.cover, // Ensures the image fills the area
            ),
          ),
          Text(
            name,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.03, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  category,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  price,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
