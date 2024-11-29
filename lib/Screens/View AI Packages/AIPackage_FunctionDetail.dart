import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/theme/color.dart';

class AIPackage_FunctionDetail extends StatelessWidget {
  const AIPackage_FunctionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(),
          SizedBox(height: MaximumThing * 0.03),
          Text(
            'Event Details',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.025,
                fontWeight: FontWeight.w600,
                color: Colors.yellow),
          ),
          SizedBox(height: MaximumThing * 0.02),
          SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget',
                      style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.026,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text("100,000",
                      style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.026,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              )),
          SizedBox(height: MaximumThing * 0.02),
          Expanded(
            child: SizedBox(
              width: screenWidth * 0.9,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Productcard(
                      onpressed: () {
                        Navigator.pushNamed(
                            context, '/AIPackage_FunctionDetail');
                      },
                      imageUrl:
                          "https://prestigiousvenues.com/wp-content/uploads/bb-plugin/cache/Gala-Dinner-Venue-In-London-Gibson-Hall-Prestigious-Venues-panorama-e59dc799b93c25c0dc960e904af705e0-59099a98687f6.jpg",
                      venueName: "Qasr-e-Noor",
                      location: "North Nazimabad - Block M - Karachi",
                      type: "Venue");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
