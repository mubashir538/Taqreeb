import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class VenueCategory extends StatelessWidget {
  const VenueCategory({super.key});

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
            Container(
              height: 1700,
              width: 428,
              decoration: BoxDecoration(
                color: MyColors.Dark,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Qasr - e - Noor Banquet",
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
                      Text(
                        "North Nazimabad Block M, Karachi",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
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
                      SizedBox(width: 40),
                      Text(
                        "Rs. 200,000 - 700000",
                        style: GoogleFonts.montserrat(
                          fontSize: 21,
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
                        "Basic Price: :",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 180),
                      Text(
                        "200,000",
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
                          "Qasr-e-Noor is a premier marriage hall located in the heart of Karachi, offering an elegant and spacious venue for weddings, receptions, and other special events. The hall is designed to accommodate both large and intimate gatherings, with luxurious interiors, state-of-the-art facilities, and exceptional services to make your event unforgettable. Qasr-e-Noor prides itself on its attention to detail, professional staff, and a wide range of customizable options, including decor, catering, and event planning, ensuring a seamless and memorable experience for all guests.",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
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
                        "Venue Type",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 180),
                      Text(
                        "Banquet",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                        "Catering",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 130),
                      Text(
                        "Internal & External",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                        "Guests",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 155),
                      Text(
                        "200- 500 Persons",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                        "Staff",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 280),
                      Text(
                        "Male",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
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
                        "Add-Ons",
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
                        "Decorations",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 175),
                      Text(
                        "Rs. 30,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                        "Female Staff",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 175),
                      Text(
                        "Rs. 10,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
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
                        "Extra Staff",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.Yellow,
                        ),
                      ),
                      SizedBox(width: 160),
                      Text(
                        "Rs. 100/Person",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: MyColors.white,
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
                              packagename: 'standard Package')),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      SizedBox(
                          width: 346,
                          child: PackageBox(
                              packagedetails: '',
                              packageprice: '',
                              packagename: 'standard Package')),
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
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "REviews",
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
                  ColoredButton(text: 'Book Venue')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
