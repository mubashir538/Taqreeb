import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class Categoryview_Makeup extends StatelessWidget {
  const Categoryview_Makeup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Container(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5DJA0WgEFo7X9kXf00EtVnpGPD3mAvh1e8A&s',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 2000,
              width: 428,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Nabila's Salon and Spa",
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 30),
                      Icon(
                        Icons.add,
                        color: MyColors.Yellow,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        Icons.star,
                        color: MyColors.Yellow,
                      ),
                      Text(
                        "4.5 (30)",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 10),
                      // SvgPicture.asset(MyIcons.mapMarker,
                      // height: 20,width: 20,)
                      // Icon(Icons.mapMarker,
                      // color: MyColors.Yellow,),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Pricing:",
                        style: GoogleFonts.montserrat(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 90),
                      Text(
                        "Rs. 18,000 - 25,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Basic Price:",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 180),
                      Text(
                        "25,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Description",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          "Nabila’s makeup services are renowned for their flawless artistry and attention to detail. Whether it's a natural look or full glam, their team creates stunning results that enhance your beauty. With expert techniques and premium products, Nabila ensures you look your absolute best.",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: MyColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Makeups Available",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Party Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "No Makeup Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 200),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Bridal Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Smokey Eye Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 185),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Hollywood Retro Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Soft Glam Makeup",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //grey container lgyga
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Vip Lounge",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 240),
                      Text(
                        "5000",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Best Artist",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 250),
                      Text(
                        "3000",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Packages",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      SizedBox(
                          width: 346,
                          child: PackageBox(
                              packagedetails: '',
                              packageprice: '',
                              packagename: 'Luxury Package')),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Makeup as per your choice",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Hair Styling",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Dupatta Setting",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Nails",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    SizedBox(width: 20),
                    Text(
                      "Vip Lounge",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      SizedBox(width: 300),
                      Text(
                        "25,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  //grey container lgyga
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Unleash your inner beauty with\n" "every stroke!",
                        style: GoogleFonts.montserrat(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Reviews",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(
                        width: 260,
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "30 Reviews",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.star,
                        color: MyColors.Yellow,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "4.5 ",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "5 Stars",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "21",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        "4 Stars",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "10",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        "3 Stars",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "8",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "2 Stars",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "3",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Text(
                        "1 Stars",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "2",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.Yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: 324,
                      child: Divider(
                        color: MyColors.DarkLighter,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  ColoredButton(text: 'Book Appointments')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
