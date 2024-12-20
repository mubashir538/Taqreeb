import 'package:flutter/material.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchService extends StatelessWidget {
  const SearchService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                // SearchBox()
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Your Search",
                      style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: MyColors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    itemBuilder: (context, index) => Productcard(
                        listingType: '',
                        listingid: '',
                        imageUrl:
                            'https://media-api.xogrp.com/images/2c80fca0-cd62-4404-8bab-7152674314c1~rs_768.h',
                        venueName: 'Region Banquet',
                        location: 'North Nazimabad block J',
                        type: 'Venue'),
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics()),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
