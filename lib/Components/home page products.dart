import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class HomePageProducts extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  final String price;

  const HomePageProducts(
      {super.key,
      required this.image,
      required this.name,
      required this.category,
      required this.price});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      color: MyColors.whiteDarker,
      height: screenHeight * 0.4,
      width: screenWidth * 0.4,
      child: Column(
        children: [
          Image.network(image,
              height: MaximumThing * 0.2,
              width: MaximumThing * 0.2,
              fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                  Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          }, errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
            return Text('Failed to load image');
          }),
          Text(
            name,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.03, fontWeight: FontWeight.w500),
          ),
          Text(
            category,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02, fontWeight: FontWeight.w400),
          ),
          Text(
            price,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.02, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
