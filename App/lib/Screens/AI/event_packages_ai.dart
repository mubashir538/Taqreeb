import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/AI/c_ai_packages.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';


class ViewAIPackage extends StatelessWidget {
  const ViewAIPackage({super.key});

  @override
  Widget build(BuildContext context) {
    
     
    
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(),
          SizedBox(height: Screen.max(context) * 0.03),
          Text(
            'Your Suggested Packages',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w600,
                color: Colors.yellow),
          ),
          SizedBox(height: Screen.max(context) * 0.02),
          Expanded(
            child: SizedBox(
              width: Screen.width(context) * 0.9,
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
