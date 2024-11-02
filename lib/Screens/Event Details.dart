import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Header(
            heading: "Your Event Details",
            image: MyImages.EventDetails,
          ),
          Text(
            'WishFa',
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyColors.Yellow),
          ),

          SizedBox(height: screenHeight * 0.02),

          // function card calling
          Function12(),
          SizedBox(
            height: 10,
          ),
          Function12(),

          //List Buttons
          Container(
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("View Guest List"),
            height: 25,
          ),
          SizedBox(height: 30),

          Container(
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("View Check  List"),
            height: 25,
          ),
          SizedBox(height: 30),

          Container(
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("View Invitation Card"),
            height: 25,
          ),
          SizedBox(height: 30),

          //icon (yh call ni horha)
          Image.asset(MyIcons.add),

          // divider
          MyDivider(width: screenWidth * 0.8),
          const SizedBox(height: 20),

          //Colored Button
          ColoredButton(
            text: 'Create Event',
            height: screenHeight * 0.09,
            width: screenWidth * 0.3,
          ),
        ]),
      ),
    );
  }
}
