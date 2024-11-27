import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class ViewFunctionsScreen extends StatelessWidget {
  const ViewFunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Header(
              heading: "Your Function Details",
              image: MyImages.CheckList, //image folder mn mojood ni hai
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'WishFa',
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1762,
              width: 374,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: MyColors.DarkLighter,
              ),
              child: Column(
                children: [
                  Container(
                    height: 76,
                    width: 374,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      color: MyColors.red,
                    ),
                    child: Center(
                      child: Text(
                        "Mehendi ",
                        style: GoogleFonts.montserrat(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffEDF2F4)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1686,
                    width: 374,
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                    ),
                    child: Column(children: [
                      //text 1
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Budget: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffEDF2F4)),
                          ),
                          SizedBox(
                            width: 160,
                          ),
                          Text(
                            "200,000 ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffEDF2F4)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //text 2
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Budget: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                          SizedBox(
                            width: 185,
                          ),
                          Text(
                            "200,000,000 ",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //text 3
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Event Type",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                          SizedBox(
                            width: 200,
                          ),
                          Text(
                            "Shaadi",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //text 4
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Guests",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                          SizedBox(
                            width: 220,
                          ),
                          Text(
                            "400-600",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //text 5
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Date",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                          SizedBox(
                            width: 190,
                          ),
                          Text(
                            "15- 20 / Dec / 24 ",
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //divider
                      MyDivider(width: screenWidth * 0.6),
                      const SizedBox(height: 10),

                      //Venue
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                            "Venue: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      //Product Card: Banquet
                      Productcard(
                        imageUrl:
                            "https://i.ytimg.com/vi/Ipgwk6VsAFA/maxresdefault.jpg",
                        venueName: "The Mansion",
                        location: "Karachi",
                        type: 'Venue',
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //Photographer
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                            "Photographer: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      //Product Card: Photographer
                      Productcard(
                        imageUrl:
                            "https://tse4.mm.bing.net/th?id=OIP.yyNmzQIoPY519auR-e1AfgAAAA&pid=Api&P=0&h=220",
                        venueName: "Mosako Hirata",
                        location: "Karachi",
                        type: 'Male/Female',
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //Salon
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                            "Salon: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      //Product Card: Salon
                      Productcard(
                        imageUrl:
                            "https://tse1.mm.bing.net/th?id=OIP.nqTGELzA5pGayw6DEbV5UQHaEo&pid=Api&P=0&h=220",
                        venueName: "Nabila's Salon and Spa",
                        location: "Karachi",
                        type: 'salon',
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      //Caters
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                          ),
                          Text(
                            "Caters: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffffbe0b)),
                          ),
                        ],
                      ),
                      //Product Card: Caters
                      Productcard(
                        imageUrl:
                            "https://tse1.mm.bing.net/th?id=OIP.PYU0xPDKXpVfbxgSm4pmzgHaE8&pid=Api&P=0&h=220",
                        venueName: "Events by Harbor",
                        location: "Karachi",
                        type: 'Caters',
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //divider
                      MyDivider(width: screenWidth * 0.6),
                      const SizedBox(height: 20),

                      //List Buttons
                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.Dark,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("View Guest List"),
                        height: 30,
                        width: 300,
                      ),
                      SizedBox(height: 30),

                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.Dark,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("View Check List"),
                        height: 30,
                        width: 300,
                      ),
                      SizedBox(height: 30),

                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.Dark,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("View Invitation Card"),
                        height: 30,
                        width: 300,
                      ),
                      SizedBox(height: 30),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),

            //divider
            MyDivider(width: screenWidth * 0.6),
            const SizedBox(height: 20),

            //colored Button
            ColoredButton(
              text: 'Create Event',
            ),
          ],
        ),
      ),
    ));
  }
}
