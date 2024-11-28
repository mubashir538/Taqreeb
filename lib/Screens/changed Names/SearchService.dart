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
                Productcard(
                    imageUrl:
                        'https://media-api.xogrp.com/images/2c80fca0-cd62-4404-8bab-7152674314c1~rs_768.h',
                    venueName: 'Region Banquet',
                    location: 'North Nazimabad block J',
                    type: 'Venue'),
                SizedBox(
                  height: 20,
                ),

                Productcard(
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKINjquFitpWn3n0jmcuUFmX6aE1usSAhF6g&s',
                    venueName: 'Syeds Caters',
                    location: 'Gulshan-e-Iqbal',
                    type: 'Catering'),
                SizedBox(
                  height: 20,
                ),
                Productcard(
                    imageUrl:
                        'https://hannawalkowaik.com/wp-content/uploads/2023/07/12_orange-county-photographer-editorial-wedding-portraits-0039.jpg',
                    venueName: 'Shadi Grapher',
                    location: 'Malir Karachi',
                    type: 'Photographers')
              ],
            )
          ],
        ),
      ),
    );
  }
}
