import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Rating/c_listing_info.dart';
import 'package:taqreeb/Components/Rating/c_rating_bar.dart';
import 'package:taqreeb/Components/Rating/c_rating_filter.dart';
import 'package:taqreeb/Components/Rating/c_review_card.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class ReviewScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': "Michael Thompson",
      'profileUrl': "https://picsum.photos/id/30/600/300",
      'stars': 5,
      'heading': "Excellent Build Quality and Features",
      'message':
          "The smartwatch exceeds expectations in every way. The build quality is premium, and the features are comprehensive. Battery life is impressive, lasting over a week with moderate use. The health tracking features are accurate and the display is bright and responsive.",
      'days': "2",
      'pictures': [
        "https://picsum.photos/id/31/600/300",
        "https://picsum.photos/id/32/600/300",
      ],
    },
    // Add more reviews here as needed
  ];

  @override
  Widget build(BuildContext context) {
    final maxDimension = _calculateMaxDimension(context);

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: _buildScreenContent(context, maxDimension),
    );
  }

  double _calculateMaxDimension(BuildContext context) {
    return Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
  }

  Widget _buildScreenContent(BuildContext context, double maxDimension) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          _buildProductInfo(),
          _buildDivider(context),
          _buildRatingFilter(),
          _buildDivider(context),
          _buildRatingDistribution(),
          _buildDivider(context),
          _buildReviewsList(),
          _buildLoadMoreButton(context),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return const ProductInfo(
      rating: 4.5,
      reviews: 500,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return MyDivider(
      thickness: 0.5,
      width: Screen.width(context),
    );
  }

  Widget _buildRatingFilter() {
    return RatingFilter(
      controller: _searchController,
    );
  }

  Widget _buildRatingDistribution() {
    return RatingDistribution(
      ratingPercentages: {5: 50, 4: 30, 3: 10, 2: 5, 1: 5},
    );
  }

  Widget _buildReviewsList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return ReviewCard(
          name: review['name'],
          profileUrl: review['profileUrl'],
          stars: review['stars'],
          heading: review['heading'],
          message: review['message'],
          days: review['days'],
          pictures: review['pictures'],
        );
      },
      itemCount: _reviews.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Container(
      width: Screen.width(context),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      color: MyColors.DarkLighter,
      child: Text(
        "Load More",
        style: GoogleFonts.montserrat(
          color: MyColors.red,
          fontSize: Screen.max(context) * 0.015,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
