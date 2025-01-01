import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productcard extends StatefulWidget {
  final String imageUrl;
  final String venueName;
  final String location;
  final bool isBusiness;
  // final Function onpressed;
  final String type;
  final double mywidth;
  final String listingid;
  final String listingType;
  Productcard({
    this.mywidth = 0,
    this.isBusiness = false,
    // this.onpressed = () {
    // },
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
        if (widget.listingType == "Venue") {
          path = '/CategoryView_Venue';
        } else if (widget.listingType == "Graphic Designer") {
          path = '/CategoryView_GraphicDesigner';
        } else if (widget.listingType == "Video Editor") {
          path = '/CategoryView_VideoEditor';
        } else if (widget.listingType == "Bakers And Sweets") {
          path = '/CategoryView_BakerySweet';
        } else if (widget.listingType == "Salon") {
          path = '/CategoryView_Salon';
        } else if (widget.listingType == "Parlor") {
          path = '/CategoryView_Parlour';
        } else if (widget.listingType == "Decorator") {
          path = '/CategoryView_Decorator';
        } else if (widget.listingType == "Car Renter") {
          path = '/CategoryView_CarRenter';
        } else if (widget.listingType == "Photographer") {
          path = '/CategoryView_Photographer';
        } else if (widget.listingType == "Caterer") {
          path = '/CategoryView_Caterers';
        }
        // else if (widget.listingType == "Function") {
        //   path = '/CategoryView_PhotographyPlace';
        // }
        //else if(widget.listingType == "Event"){

        // }
        // else if(widget.listingType == "Function"){

        // }else if(widget.listingType == "Event"){

        // }
        Navigator.pushNamed(context, path,
            arguments: {'id': int.parse(widget.listingid),'isBusiness':widget.isBusiness});
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
