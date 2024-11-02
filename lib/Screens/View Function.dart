import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class ViewFunctionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: MyColors.black,
        body: Column(children: [
          Header(
            heading: "Your Function Details",
            image: MyImages.CheckList, //image folder mn mojood ni hai
          ),
        Text('WishFa',
        style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: MyColors.Yellow),
                ),

        // function card calling
       // funtion("Mehendi", "200,000", "15 Dec - 24", MyColors.red),
      
        ]
      )
    );
  }
}
