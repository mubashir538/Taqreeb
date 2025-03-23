import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class RecieveMessage extends StatelessWidget {
  final String text;
  final String time;
  final String? imageUrl;
  final String? audioUrl;

  const RecieveMessage({
    super.key,
    required this.text,
    required this.time,
    this.imageUrl,
    this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
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
              color: MyColors.DarkLighter,
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
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: Screen.width(context) * 0.6,
                    ),
                  ),
                if (text.isNotEmpty)
                  Text(
                    text,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white,
                    ),
                  ),
                if (audioUrl != null)
                  Row(
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
          SizedBox(width: 15),
          Text(
            time,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: Screen.max(context) * 0.013,
            ),
          ),
        ],
      ),
    );
  }
}
