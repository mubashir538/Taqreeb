import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryReview extends StatefulWidget {
  final Map listing;
  final List<String> starsvalue;

  static const List<String> stars = [
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars',
  ];

  const CategoryReview({
    super.key,
    required this.listing,
    required this.starsvalue,
  });

  @override
  State<CategoryReview> createState() => _CategoryReviewState();
}

class _CategoryReviewState extends State<CategoryReview> {
  TextStyle _buildTextStyle({
    double fontSize = 0.015,
    FontWeight fontWeight = FontWeight.w400,
    required Color color,
  }) {
    return GoogleFonts.montserrat(
      fontSize: Screen.max(context) * fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews',
          style: _buildTextStyle(
            fontSize: 0.025,
            fontWeight: FontWeight.w600,
            color: MyColors.yellow,
          ),
        ),
        GestureDetector(
          onTap: _navigateToReviewPage,
          child: Text(
            'View All',
            style: _buildTextStyle(
              fontSize: 0.015,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToReviewPage() {
    Navigator.pushNamed(context, '/ReviewPage', arguments: widget.listing);
  }

  Widget _buildRatingSummary() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Screen.max(context) * 0.02,
      ),
      child: Row(
        children: [
          Text(
            '${widget.listing['Listing']['ratingCount'].toString()} Reviews',
            style: _buildTextStyle(color: MyColors.white),
          ),
          SizedBox(width: Screen.width(context) * 0.02),
          Icon(Icons.star, color: MyColors.yellow),
          SizedBox(width: Screen.width(context) * 0.02),
          Text(
            widget.listing['Listing']['rating'].toString(),
            style: _buildTextStyle(color: MyColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingRow(String star) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            star,
            style: _buildTextStyle(
                fontWeight: FontWeight.w500, color: MyColors.white),
          ),
          Text(
            widget.starsvalue[CategoryReview.stars.indexOf(star)],
            style: _buildTextStyle(
              fontWeight: FontWeight.w500,
              color: MyColors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderRow(),
        _buildRatingSummary(),
        ...CategoryReview.stars.map(_buildStarRatingRow),
      ],
    );
  }
}
