import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';


class SlidingRow extends StatelessWidget {
  final String title;
  final List<String> images;

  const SlidingRow({required this.title, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColors.Yellow,
                ),
              ),
              Text(
                "see all",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: Screen.width(context) * 0.4,
            child: Scrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        width: Screen.width(context) * 0.3,
                        height: Screen.width(context) * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
