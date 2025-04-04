import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ReviewCard extends StatelessWidget {
  final String name;
  final String profileUrl;
  final int stars;
  final String heading;
  final String message;
  final String days;
  final List<String>? pictures;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.profileUrl,
    required this.stars,
    required this.heading,
    required this.message,
    required this.days,
    this.pictures,
  }) : super(key: key);

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
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(max * 0.01),
        boxShadow: [
          BoxShadow(
            color: MyColors.Dark.withOpacity(0.1),
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
                backgroundImage: NetworkImage(profileUrl),
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
                    "$days ago",
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
              for (int i = 0; i < stars; i++)
                Icon(Icons.star_rounded,
                    color: MyColors.red, size: max * 0.025),
              for (int i = 0; i < (5 - stars); i++)
                Icon(Icons.star_border_rounded,
                    color: MyColors.red, size: max * 0.025),
            ],
          ),
          SizedBox(height: max * 0.02),
          Text(
            heading,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
              fontSize: max * 0.017,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: max * 0.01),
          Text(
            message,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
              fontSize: max * 0.015,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (pictures != null && pictures!.isNotEmpty) ...[
            SizedBox(height: max * 0.02),
            SizedBox(
              height: max * 0.1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pictures!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: max * 0.01),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(max * 0.01),
                      child: CachedNetworkImage(
                        imageUrl: pictures![index],
                        width: max * 0.1,
                        height: max * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
