import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryView_VideoEditor extends StatelessWidget {
  const CategoryView_VideoEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            Container(
              child: Image.network(
                // 'data:image/jpeg;base64,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',
                'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220',
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
