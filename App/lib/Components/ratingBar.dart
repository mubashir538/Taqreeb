import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class RatingDistribution extends StatelessWidget {
  final Map<int, double> ratingPercentages;

  const RatingDistribution({Key? key, required this.ratingPercentages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double max = screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      padding: EdgeInsets.all(max * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rating Distribution",
            style: GoogleFonts.montserrat(
              color: MyColors.whiteDarker,
              fontSize: max * 0.02,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: max * 0.02),
          for (var entry in ratingPercentages.entries)
            Padding(
              padding: EdgeInsets.symmetric(vertical: max * 0.005),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.2,
                    child: Text(
                      "${entry.key}★ ${entry.value}%",
                      style: GoogleFonts.montserrat(
                        color: MyColors.whiteDarker,
                        fontSize: max * 0.013,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: max * 0.02),
                  Expanded(
                    child: LinearProgressIndicator(
                      minHeight: screenHeight*0.02,
                      value: entry.value / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.red),
                    ),
                  ),
                  
                ],
              ),
            ),
        ],
      ),
    );
  }
}
