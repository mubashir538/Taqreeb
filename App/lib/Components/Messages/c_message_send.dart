import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SendMessage extends StatelessWidget {
  final String text;
  final String time;
  final String? imageUrl;
  final String? audioUrl;
  final Map<String, dynamic>? listing; // Add this line

  const SendMessage({
    super.key,
    required this.text,
    required this.time,
    this.imageUrl,
    this.audioUrl,
    this.listing, // Add this line
  });

  Widget _buildListingPreview(BuildContext context) {
    if (listing == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Listing name
          Text(
            listing!['name'] ?? '',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyColors.white,
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
                    '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listing!['picture']}',
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
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: MyColors.white.withAlpha(178),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          SizedBox(height: 4),

          // Website link
          Text(
            'www.taqreeb.com', // Replace with your actual domain
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: MyColors.Yellow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
      margin: EdgeInsets.only(bottom: Screen.max(context) * 0.02),
      width: Screen.width(context) * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            time,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: Screen.max(context) * 0.013,
            ),
          ),
          SizedBox(width: 15),
          Container(
            constraints: BoxConstraints(maxWidth: Screen.width(context) * 0.7),
            padding: EdgeInsets.all(Screen.max(context) * 0.02),
            decoration: BoxDecoration(
              color: MyColors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    textAlign: TextAlign.end,
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                  ),
                if (audioUrl != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.audiotrack, color: MyColors.white),
                      SizedBox(width: 8),
                      Text(
                        "Voice Note",
                        style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontSize: Screen.max(context) * 0.015,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
