import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/productInfo.dart';
import 'package:taqreeb/Components/ratingBar.dart';
import 'package:taqreeb/Components/ratingFilter.dart';
import 'package:taqreeb/Components/reviewCard.dart';
import 'package:taqreeb/theme/color.dart';

// ignore: must_be_immutable
class ReviewScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double max = screenWidth > screenHeight ? screenWidth : screenHeight;
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
              width: screenWidth,
            ),
            RatingFilter(
              controller: controller,
            ),
            MyDivider(
              thickness: 0.5,
              width: screenWidth,
            ),
            RatingDistribution(
              ratingPercentages: {5: 50, 4: 30, 3: 10, 2: 5, 1: 5},
            ),
            MyDivider(
              thickness: 0.5,
              width: screenWidth,
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
              width: screenWidth,
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
