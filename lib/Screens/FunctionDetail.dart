import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class FunctionDetail extends StatelessWidget {
  const FunctionDetail({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    List<String> headings = ['Function Type', 'Guests', 'Date'];
    List<String> values = ['Barat', '200-600', '15 Dec 24'];
    List<String> bookinglist = ['Venue', 'Saloon', 'Photographer'];
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Header(
              heading: "Your Function Details",
              image: MyImages.CheckList, //image folder mn mojood ni hai
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.03),
              child: Text(
                'WishFa',
                style: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.03,
                    fontWeight: FontWeight.w700,
                    color: MyColors.Yellow),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: MyColors.DarkLighter,
              ),
              child: Column(
                children: [
                  Container(
                    width: screenWidth * 0.9,
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w600,
                            color: MyColors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                    ),
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.all(MaximumThing * 0.02),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Budget',
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.02,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.white),
                            ),
                            Text(
                              '150,000',
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.02,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.white),
                            ),
                          ],
                        ),
                      ),

                      for (var heading in headings)
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: MaximumThing * 0.005,
                              horizontal: MaximumThing * 0.02),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                heading,
                                style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.Yellow),
                              ),
                              Text(
                                values[headings.indexOf(heading)],
                                style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(
                        height: screenHeight * 0.1,
                        child: Center(child: MyDivider()),
                      ),

                      for (var list in bookinglist)
                        Column(
                          children: [
                            Text(
                              list,
                              style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.02,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.Yellow),
                            ),
                            Productcard(
                              mywidth: screenWidth * 0.85,
                              onpressed: () {
                                Navigator.pushNamed(
                                    context, '/CategoryView_Venue');
                              },
                              imageUrl:
                                  "https://i.ytimg.com/vi/Ipgwk6VsAFA/maxresdefault.jpg",
                              venueName: "The Mansion",
                              location: "Karachi",
                              type: 'Venue',
                            ),
                          ],
                        ),

                      //divider
                      MyDivider(width: screenWidth * 0.6),
                      const SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.all(MaximumThing * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03),
                        decoration: BoxDecoration(
                            color: MyColors.DarkLighter,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ]),
                        width: screenWidth * 0.8,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/CreateGuestList');
                            },
                            child: Text("View GuestList")),
                      ),

                      Container(
                        margin: EdgeInsets.all(MaximumThing * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03),
                        decoration: BoxDecoration(
                            color: MyColors.DarkLighter,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ]),
                        width: screenWidth * 0.8,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/CreateChecklistItems');
                            },
                            child: Text("View CheckLlist")),
                      ),

                      Container(
                        margin: EdgeInsets.all(MaximumThing * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03),
                        decoration: BoxDecoration(
                            color: MyColors.DarkLighter,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ]),
                        width: screenWidth * 0.8,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/InvitationCardEdit');
                            },
                            child: Text("View Invitation Card")),
                      ),
                      Container(
                        margin: EdgeInsets.all(MaximumThing * 0.02),
                        width: screenWidth * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              MyIcons.add,
                              color: MyColors.white,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            )
          ],
        ),
      ),
    ));
  }
}
