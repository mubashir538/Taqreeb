import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class RatingDistribution extends StatelessWidget {
  final Map<int, double> ratingPercentages;

  const RatingDistribution({super.key, required this.ratingPercentages});

  @override
  Widget build(BuildContext context) {
    double max = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);

    return Container(
      padding: EdgeInsets.all(max * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rating Distribution",
            style: GoogleFonts.roboto(
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
                    width: Screen.width(context) * 0.2,
                    child: Text(
                      "${entry.key}★ ${entry.value}%",
                      style: GoogleFonts.roboto(
                        color: MyColors.whiteDarker,
                        fontSize: max * 0.013,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: max * 0.02),
                  Expanded(
                    child: LinearProgressIndicator(
                      minHeight: Screen.height(context) * 0.02,
                      value: entry.value == 0 ? 1 / 100 : entry.value / 100,
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
