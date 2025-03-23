import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/AI/c_ai_functions.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

class AIPackage_EventDetail extends StatelessWidget {
  const AIPackage_EventDetail({super.key});

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
            'Package Details',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w600,
                color: Colors.yellow),
          ),
          SizedBox(height: Screen.max(context) * 0.02),
          SizedBox(
              width: Screen.width(context) * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Budget',
                      style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.026,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text("100,000",
                      style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.026,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              )),
          SizedBox(height: Screen.max(context) * 0.02),
          SizedBox(
              width: Screen.width(context) * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No. of Events',
                      style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.026,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text("5",
                      style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.026,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ],
              )),
          Expanded(
            child: SizedBox(
              width: Screen.width(context) * 0.9,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return AIFunctions(
                      onpressed: () {
                        Navigator.pushNamed(
                            context, '/AIPackage_FunctionDetail');
                      },
                      event: "Mehendi",
                      date: "24-Nov-2024",
                      price: "50,000");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
