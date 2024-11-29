import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productcard extends StatelessWidget {
  final String imageUrl;
  final String venueName;
  final String location;
  final Function onpressed;
  final String type;
  final double mywidth;

  const Productcard({
    this.mywidth = 0,
    required this.onpressed,
    required this.imageUrl,
    required this.venueName,
    required this.location,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: () => onpressed(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
        width: mywidth == 0 ? screenWidth * 0.7 : mywidth,
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.1,
                padding: EdgeInsets.all(MaximumThing * 0.01),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          venueName,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          type,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      location,
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.015,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
