import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/AI%20Functions.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/theme/color.dart';

class AIPackageDetails extends StatelessWidget {
  const AIPackageDetails({super.key});

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
            'Package Details',
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
          SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No. of Events',
                      style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.026,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text("5",
                      style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.026,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              )),
          Expanded(
            child: Container(
              width: screenWidth * 0.9,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return AIFunctions(
                      event: "Mehendi", date: "24-Nov-2024", price: "50,000");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
