import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productcard extends StatefulWidget {
  final String imageUrl;
  final String venueName;
  final String location;
  final bool isBusiness;
  final String type;
  final double mywidth;
  final String listingid;
  final String listingType;
  Productcard({
    this.mywidth = 0,
    this.isBusiness = false,
    required this.listingid,
    required this.listingType,
    required this.imageUrl,
    required this.venueName,
    required this.location,
    required this.type,
    super.key,
  });

  @override
  State<Productcard> createState() => _ProductcardState();
}

String toLowerCaseNoSpaces(String input) {
  return input.toLowerCase().replaceAll(' ', '');
}

class _ProductcardState extends State<Productcard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return InkWell(
      onTap: () {
        String path = '';
        final listingType = toLowerCaseNoSpaces(widget.listingType);
        if (listingType == toLowerCaseNoSpaces("venue")) {
          path = '/CategoryView_Venue';
        } else if (listingType == toLowerCaseNoSpaces("graphicdesigner")) {
          path = '/CategoryView_GraphicDesigner';
        } else if (listingType == toLowerCaseNoSpaces("Video Editor")) {
          path = '/CategoryView_VideoEditor';
        } else if (listingType == toLowerCaseNoSpaces("Baker And Sweet")) {
          path = '/CategoryView_BakerySweet';
        } else if (listingType == toLowerCaseNoSpaces("Salon")) {
          path = '/CategoryView_Salon';
        } else if (listingType == toLowerCaseNoSpaces("Parlour")) {
          path = '/CategoryView_Parlour';
        } else if (listingType == toLowerCaseNoSpaces("Decorator")) {
          path = '/CategoryView_Decorator';
        } else if (listingType == toLowerCaseNoSpaces("Car Renter")) {
          path = '/CategoryView_CarRenter';
        } else if (listingType == toLowerCaseNoSpaces("Photographer")) {
          path = '/CategoryView_Photographer';
        } else if (listingType == toLowerCaseNoSpaces("Photography place")) {
          path = '/CategoryView_PhotographyPlace';
        } else if (listingType == toLowerCaseNoSpaces("Caterer")) {
          path = '/CategoryView_Caterers';
        }
        Navigator.pushNamed(context, path, arguments: {
          'id': int.parse(widget.listingid),
          'isBusiness': widget.isBusiness
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
        width: widget.mywidth == 0 ? screenWidth * 0.7 : widget.mywidth,
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.venueName.length > 20
                              ? "${widget.venueName.substring(0, 20)}..."
                              : widget.venueName,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          widget.location.length > 30
                              ? "${widget.location.replaceAll('\n', '').replaceAll('\r', '').substring(0, 30)}..."
                              : widget.location
                                  .replaceAll('\n', '')
                                  .replaceAll('\r', ''),
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        widget.type,
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
