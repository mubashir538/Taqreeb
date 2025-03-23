import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Rating/c_listing_info.dart';
import 'package:taqreeb/Components/Rating/c_rating_bar.dart';
import 'package:taqreeb/Components/Rating/c_rating_filter.dart';
import 'package:taqreeb/Components/Rating/c_review_card.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

// ignore: must_be_immutable
class ReviewScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double max = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            ProductInfo(rating: 4.5, reviews: 500),
            MyDivider(
              thickness: 0.5,
              width: Screen.width(context),
            ),
            RatingFilter(
              controller: controller,
            ),
            MyDivider(
              thickness: 0.5,
              width: Screen.width(context),
            ),
            RatingDistribution(
              ratingPercentages: {5: 50, 4: 30, 3: 10, 2: 5, 1: 5},
            ),
            MyDivider(
              thickness: 0.5,
              width: Screen.width(context),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return ReviewCard(
                  name: "Michael Thompson",
                  profileUrl: "https://picsum.photos/id/30/600/300",
                  stars: 5,
                  heading: "Excellent Build Quality and Features",
                  message:
                      "The smartwatch exceeds expectations in every way. The build quality is premium, and the features are comprehensive. Battery life is impressive, lasting over a week with moderate use. The health tracking features are accurate and the display is bright and responsive.",
                  days: "2",
                  pictures: [
                    "https://picsum.photos/id/31/600/300",
                    "https://picsum.photos/id/32/600/300",
                  ],
                );
              },
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
            SizedBox(height: max * 0.02),
            Container(
              width: Screen.width(context),
              padding: EdgeInsets.all(max * 0.02),
              color: MyColors.DarkLighter,
              child: Text("Load More",
                  style: GoogleFonts.montserrat(
                      color: MyColors.red,
                      fontSize: max * 0.015,
                      fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}
