import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MaximumThing * 0.01, vertical: MaximumThing * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: MaximumThing * 0.03,
              backgroundImage: NetworkImage(
                imageUrl,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MaximumThing * 0.004),
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.015,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
