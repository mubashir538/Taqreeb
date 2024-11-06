import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class Parlors extends StatelessWidget {
  const Parlors({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Header(
              heading: "Parlors",
              para: "Where beauty meets elegance!",
            ),
            SizedBox(
              height: 30,
            ),

            //Text
            Text(
              "Elevate your bridal experience with top artists in Karachi that\n"
              "fit your budget on Taqreeb. Explore comprehensive details\n"
              "about salon makeup artists, hairstylists, their pricing, and\n"
              "more!",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  color: MyColors.white),
            ),
            SizedBox(
              height: 30,
            ),

            //Spa and Services
            Container(
              height: 170,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: MyColors.DarkLighter,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Image.asset("https://wolfcoveinn.com/wp-content/uploads/2019/01/WolfCove-spa-slide-1.jpg",
                  // width: 20,
                  // height: 30,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Spa and Services"),
                      MyDivider(
                        width: 50,
                      ),
                      Text("Indulge in a variety of\n" 
                      "spa services, from \n"
                      "soothing massages to\n" 
                      "revitalizing facials, for\n" 
                      "the ultimate wellness\n" 
                      "experience.",
                      textAlign: TextAlign.end,
                      style: GoogleFonts.montserrat(
                        fontSize: 9,
                        fontWeight: FontWeight.w200,
                        color: MyColors.white
                      ),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),

            
            //Makeup
            Container(
              height: 170,
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: MyColors.DarkLighter,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Image.asset("https://wolfcoveinn.com/wp-content/uploads/2019/01/WolfCove-spa-slide-1.jpg",
                  // width: 20,
                  // height: 30,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("MakeUp"),
                      MyDivider(
                        width: 40,
                      ),
                      Text("Enhance your natural\n" 
                      "beauty with expertly\n" 
                      "applied makeup, tailored\n" 
                      "to highlight your best\n" 
                      "features. Perfect for any\n" 
                      "occasion, from casual\n" 
                      "outings to glamorous\n"
                      "events.",
                      textAlign: TextAlign.end,
                      style: GoogleFonts.montserrat(
                        fontSize: 9,
                        fontWeight: FontWeight.w200,
                        color: MyColors.white
                      ),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),

            //Divider
            MyDivider(width: screenWidth * 0.6),
            const SizedBox(height: 20),

            //Colored Button
            ColoredButton(text: 'Continue'),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}