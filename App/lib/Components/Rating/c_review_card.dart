import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String profileUrl;
  final String stars;
  final String message;
  final String days;

  const ReviewCard({
    super.key,
    required this.name,
    required this.profileUrl,
    required this.stars,
    required this.message,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    double max = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);

    return Container(
      margin:
          EdgeInsets.symmetric(vertical: max * 0.01, horizontal: max * 0.02),
      padding: EdgeInsets.all(max * 0.02),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.circular(max * 0.01),
        boxShadow: [
          BoxShadow(
            color: MyColors.dark.withAlpha(25),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$profileUrl',
                ),
                radius: max * 0.03,
              ),
              SizedBox(width: max * 0.015),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontSize: max * 0.015,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    days,
                    style: GoogleFonts.montserrat(
                      color: MyColors.whiteDarker,
                      fontSize: max * 0.013,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: max * 0.02),
          Row(
            children: [
              for (int i = 0; i < int.parse(stars[0]); i++)
                Icon(Icons.star_rounded,
                    color: MyColors.red, size: max * 0.025),
              if (stars.length > 1)
                Icon(Icons.star_half_rounded,
                    color: MyColors.red, size: max * 0.025),
              for (int i = 0;
                  i <
                      (5 -
                          (stars.length == 1
                              ? int.parse(stars[0])
                              : (int.parse(stars[0]) + 1)));
                  i++)
                Icon(Icons.star_border_rounded,
                    color: MyColors.red, size: max * 0.025),
            ],
          ),
          SizedBox(height: max * 0.02),
          Text(
            message,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
              fontSize: max * 0.015,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
