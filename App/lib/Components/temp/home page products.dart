import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class HomePageProducts extends StatelessWidget {
  final String image;
  final String name;
  final String category;
  final String price;
  final Function onpressed;

  const HomePageProducts({
    super.key,
    required this.onpressed,
    required this.image,
    required this.name,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Screen.max(context) * 0.01,
            vertical: Screen.max(context) * 0.02),
        height: Screen.height(context) * 0.2,
        width: Screen.width(context) * 0.4,
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: image,
                width: double.infinity,
                height: Screen.height(context) * 0.1,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              name,
              style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.015,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    category,
                    style: GoogleFonts.roboto(color: Colors.grey[600]),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.roboto(color: MyColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
