import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryReview extends StatefulWidget {
  final Map listing;
  final List<String> starsvalue;

  static const List<String> stars = [
    '5★',
    '4★',
    '3★',
    '2★',
    '1★',
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
    double fontSize = 0,
    FontWeight fontWeight = FontWeight.w400,
    required Color color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize == 0 ? Screen.max(context) * 0.015 : fontSize,
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
            fontSize: Screen.max(context) * 0.025,
            fontWeight: FontWeight.w600,
            color: MyColors.white,
          ),
        ),
        TextButton(
          onPressed: _navigateToReviewPage,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: _buildTextStyle(
              fontSize: Screen.max(context) * 0.015,
              color: MyColors.red,
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
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.02),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.listing['Listing']['rating'].toString(),
                style: GoogleFonts.poppins(
                  fontSize: Screen.height(context) * 0.035,
                  fontWeight: FontWeight.w700,
                  color: MyColors.white,
                ),
              ),
              SizedBox(width: Screen.width(context) * 0.01),
              Padding(
                padding:  EdgeInsets.only(bottom: Screen.max(context) * 0.01),
                child: Text(
                  '/5',
                  style: GoogleFonts.poppins(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Screen.max(context) * 0.01),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index <
                        double.parse(widget.listing['Listing']['rating'])
                            .floor()
                            .toInt()
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                color: MyColors.yellow,
                size: Screen.max(context) * 0.02,
              ),
            ),
          ),
           SizedBox(height: Screen.max(context) * 0.01),
          Text(
            '${widget.listing['Listing']['ratingCount']} total reviews',
            style: _buildTextStyle(
              fontSize: Screen.max(context) * 0.015,
              color: MyColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingRow(String star) {
    final starNumber = int.tryParse(star.replaceAll('★', '')) ?? 5;

    // Get the count for this star from reviewData (e.g., s5 for 5★)
    final count = widget.listing['reviewData']?['s$starNumber'] ?? 0;

    // Calculate total reviews by summing all star counts
    final totalReviews = [1, 2, 3, 4, 5].fold<int>(
        0,
        (sum, star) =>
            (sum + (widget.listing['reviewData']?['s$star'] ?? 0)).toInt());

    // Calculate percentage (handle division by zero)
    final percentage =
        totalReviews == 0 ? 0 : ((count / totalReviews) * 100).round();
    return Container(
      margin:  EdgeInsets.symmetric(vertical: Screen.max(context) * 0.007),
      child: Row(
        children: [
          SizedBox(
            width: Screen.width(context) * 0.03,
            child: Text(
              star,
              style: _buildTextStyle(
                fontSize: Screen.max(context) * 0.015,
                fontWeight: FontWeight.w500,
                color: MyColors.white,
              ),
            ),
          ),
          SizedBox(width: Screen.max(context) * 0.02),
          Expanded(
            child: LinearProgressIndicator(
              value:
                  totalReviews == 0 || count == 0 ? 0.01 : count / totalReviews,
              backgroundColor: MyColors.dark.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(MyColors.yellow),
              minHeight: Screen.max(context) * 0.01,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: Screen.max(context) * 0.01),
          SizedBox(
            width: Screen.max(context) * 0.05,
            child: Text(
              '$percentage%',
              style: _buildTextStyle(
                fontSize: Screen.max(context) * 0.015,
                fontWeight: FontWeight.w500,
                color: MyColors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.dark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
           Divider(
            color: Colors.white24,
            height: Screen.height(context) * 0.01,
          ),
          _buildRatingSummary(),
           SizedBox(height: Screen.height(context) * 0.01),
          ...CategoryReview.stars.map(_buildStarRatingRow),
        ],
      ),
    );
  }
}
