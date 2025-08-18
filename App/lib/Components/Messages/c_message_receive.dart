import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class RecieveMessage extends StatelessWidget {
  final String text;
  final String time;
  final String? imageUrl;
  final String? audioUrl;
  final Map<String, dynamic>? listing;
  final bool isBold; // Add this parameter

  const RecieveMessage({
    super.key,
    required this.text,
    required this.time,
    this.imageUrl,
    this.audioUrl,
    this.listing,
    this.isBold = false, // Default to false
  });

  Widget _buildListingPreview(BuildContext context) {
    if (listing == null) return const SizedBox.shrink();
    final colors = AppColors(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Listing name
          Text(
            listing!['name'] ?? '',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.white,
            ),
          ),
          SizedBox(height: 8),

          // Listing image if available
          if (listing!['picture'] != null &&
              listing!['picture'].toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    listing!['picture'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),

          SizedBox(height: 8),

          // Listing description
          if (listing!['description'] != null &&
              listing!['description'].toString().isNotEmpty)
            Text(
              listing!['description'] ?? '',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: colors.white.withAlpha(178),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          SizedBox(height: 4),

          // Website link
          Text(
            'www.taqreeb.com', // Replace with your actual domain
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
      margin: EdgeInsets.only(bottom: Screen.max(context) * 0.02),
      width: Screen.width(context) * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Screen.width(context) * 0.7),
            padding: EdgeInsets.all(Screen.max(context) * 0.02),
            decoration: BoxDecoration(
              color: colors.darkLighter,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (listing != null) _buildListingPreview(context),
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      width: Screen.width(context) * 0.6,
                    ),
                  ),
                if (text.isNotEmpty)
                  Text(
                    text,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                      color: isBold ? colors.yellow : colors.white,
                    ),
                  ),
                if (audioUrl != null)
                  Row(
                    children: [
                      Icon(Icons.audiotrack, color: colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Voice Note",
                        style: GoogleFonts.roboto(
                          color: colors.white,
                          fontSize: Screen.max(context) * 0.015,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Text(
            time,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              fontSize: Screen.max(context) * 0.013,
            ),
          ),
        ],
      ),
    );
  }
}
