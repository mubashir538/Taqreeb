import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryReview extends StatefulWidget {
  final Map listing;
  final List<String> stars = [
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars',
  ];
  final List<String> starsvalue;
  CategoryReview({super.key, required this.listing, required this.starsvalue});

  @override
  State<CategoryReview> createState() => _CategoryReviewState();
}

class _CategoryReviewState extends State<CategoryReview> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.montserrat(
                fontSize: maximumDimension * 0.015,
                fontWeight: FontWeight.w400,
                color: MyColors.white,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: maximumDimension * 0.02,
          ),
          child: Row(
            children: [
              Text(
                '${widget.listing['reveiewData']['count'].toString()} Reviews',
                style: GoogleFonts.montserrat(
                  fontSize: maximumDimension * 0.015,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(Icons.star, color: MyColors.Yellow),
              SizedBox(width: screenWidth * 0.02),
              Text(
                "${widget.listing['reveiewData']['average'].toString()}",
                style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.015, color: MyColors.white),
              ),
            ],
          ),
        ),
        for (var star in widget.stars)
          Container(
            margin: EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  star,
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.015,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
                Text(
                  widget.starsvalue[widget.stars.indexOf(star)],
                  style: GoogleFonts.montserrat(
                    fontSize: maximumDimension * 0.015,
                    fontWeight: FontWeight.w500,
                    color: MyColors.Yellow,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
