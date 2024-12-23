import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'dart:math';

class YourListings extends StatelessWidget {
  const YourListings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Text(
              "Your Listings",
              style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow),
            ),
            Row(
              children: [
                //SearchBox(),
                Image.asset(MyIcons.funnel)
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Productcard(
                    listingType: '',
                    listingid: '',
                    imageUrl:
                        "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
                    venueName: "Qasr-e-Noor",
                    location: "North Nazimabad",
                    type: "Venue");
              },
            )
          ],
        ),
      ),
    );
  }
}
