import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/theme/color.dart';

class AISuggestedPackages extends StatelessWidget {
  const AISuggestedPackages({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [
          Header(),
          Text('Your Suggested Packages',style: GoogleFonts.montserrat(
            fontSize: MaximumThing * 0.03,
            fontWeight: FontWeight.w600,
            color: Colors.yellow
          ),),
          
        ],
      ),
    );
  }
}
