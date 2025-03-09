import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/AI%20Package.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/theme/color.dart';

class ViewAIPackage extends StatelessWidget {
  const ViewAIPackage({super.key});

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
            'Your Suggested Packages',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.025,
                fontWeight: FontWeight.w600,
                color: Colors.yellow),
          ),
          SizedBox(height: MaximumThing * 0.02),
          Expanded(
            child: SizedBox(
              width: screenWidth * 0.9,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return AIPackage(
                      onpressed: () {
                        Navigator.pushNamed(context, '/AIPackage_EventDetail');
                      },
                      cateringCost: "5000",
                      venueCost: "10000",
                      price: "10000",
                      events: '5',
                      photographer: "Yes"
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
