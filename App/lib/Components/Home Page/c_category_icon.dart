import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imageUrl;
  final Function onpressed;

  const CategoryIcon(
      {super.key,
      required this.onpressed,
      required this.label,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Screen.max(context) * 0.01,
            vertical: Screen.max(context) * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Screen.max(context) * 0.1,
              height: Screen.max(context) * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: Screen.max(context) * 0.12),
              margin: EdgeInsets.only(top: Screen.max(context) * 0.004),
              child: Text(
                label,
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w300,
                  color: colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
