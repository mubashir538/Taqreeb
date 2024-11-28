import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextStyle heading = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.017,
        fontWeight: FontWeight.w600,
        color: MyColors.Yellow);

    TextStyle text = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.017,
        fontWeight: FontWeight.w400,
        color: MyColors.Yellow);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Header(
            heading: "Your Event Details",
            image: MyImages.EventDetails,
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'WishFa',
            style: GoogleFonts.montserrat(
                fontSize: MaximumThing * 0.03,
                fontWeight: FontWeight.w700,
                color: MyColors.Yellow),
          ),

          SizedBox(height: screenHeight * 0.02),
          SizedBox(
            width: screenWidth * 0.9,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget',
                    style: heading,
                  ),
                  Text('200,000', style: text)
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Event Type', style: heading),
                  Text('Shaadi', style: text)
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Guests', style: heading),
                  Text('200-600', style: text)
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date', style: heading),
                  Text('15-20 Dec 24', style: text)
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
            ]),
          ),
          SizedBox(height: screenHeight * 0.02),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Function12();
            },
            itemCount: 3,
          ),

          Container(
            margin: EdgeInsets.all(MaximumThing * 0.01),
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
            decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ]),
            width: screenWidth * 0.8,
            child: Text("View GuestList"),
          ),

          Container(
            margin: EdgeInsets.all(MaximumThing * 0.01),
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
            decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ]),
            width: screenWidth * 0.8,
            child: Text("View CheckLlist"),
          ),

          Container(
            margin: EdgeInsets.all(MaximumThing * 0.01),
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
            decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ]),
            width: screenWidth * 0.8,
            child: Text("View Invitation Card"),
          ),

          //icon (yh call ni horha)
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
          SizedBox(
            height: screenHeight * 0.1,
            child: Center(child: MyDivider()),
          ),

          //Colored Button
          ColoredButton(
            text: 'Create Event',
          ),
        ]),
      ),
    );
  }
}
