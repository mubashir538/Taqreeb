import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AccountInfo1 extends StatelessWidget {
  const AccountInfo1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          Header(
            heading: "My Profile",
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MaximumThing * 0.03, horizontal: MaximumThing * 0.02),
            child: Text(
                "Here is the account information for your profile,please review and ensure all details are accurate for a seamless experience.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white)),
          ),

          //Circle Avatar
          Container(
            margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.04),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://static.vecteezy.com/system/resources/previews/030/798/360/non_2x/beautiful-asian-girl-wearing-over-size-hoodie-in-casual-style-ai-generative-photo.jpg" // backgroundImage: NetworkImage(),

                    ),
              ),
              Container(
                margin: EdgeInsets.only(left: MaximumThing * 0.03),
                child: Text(
                  "Wishma khan",
                  style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.02,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white),
                ),
              ),
            ]),
          ),

          SizedBox(
            height: screenHeight * 0.1,
            child: Center(child: MyDivider()),
          ),

          Text(
            'Username',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: MaximumThing * 0.018,
              fontWeight: FontWeight.w700,
              color: MyColors.Yellow,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MaximumThing * 0.02, horizontal: MaximumThing * 0.01),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.04),
              child: Row(children: [
                SvgPicture.asset(MyIcons.profile),
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wishmak12',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w200,
                            color: MyColors.white,
                          ),
                        ),
                        MyDivider(width: screenWidth * 0.65),
                      ]),
                )
              ]),
            ),
          ),

          Text(
            'Phone',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: MaximumThing * 0.018,
              fontWeight: FontWeight.w700,
              color: MyColors.Yellow,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MaximumThing * 0.02, horizontal: MaximumThing * 0.01),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.04),
              child: Row(children: [
                Icon(
                  Icons.phone,
                  color: MyColors.white,
                  size: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '032182429727',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w200,
                            color: MyColors.white,
                          ),
                        ),
                        MyDivider(width: screenWidth * 0.65),
                      ]),
                )
              ]),
            ),
          ),

          Text(
            'Email',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: MaximumThing * 0.018,
              fontWeight: FontWeight.w700,
              color: MyColors.Yellow,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MaximumThing * 0.02, horizontal: MaximumThing * 0.01),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.04),
              child: Row(children: [
                Icon(
                  Icons.email,
                  color: MyColors.white,
                  size: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wishmak78@gmail.com',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w200,
                            color: MyColors.white,
                          ),
                        ),
                        MyDivider(width: screenWidth * 0.65),
                      ]),
                )
              ]),
            ),
          ),

          Text(
            'Location',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: MaximumThing * 0.018,
              fontWeight: FontWeight.w700,
              color: MyColors.Yellow,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MaximumThing * 0.02, horizontal: MaximumThing * 0.01),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MaximumThing * 0.04),
              child: Row(children: [
                Icon(Icons.location_pin, color: MyColors.white,size: 30,),
               
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Karachi, Pakistan',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w200,
                            color: MyColors.white,
                          ),
                        ),
                        MyDivider(width: screenWidth * 0.65),
                      ]),
                )
              ]),
            ),
          ),
        ]),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MyColors.Yellow,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.add_rounded,
          size: 40,
          color: MyColors.Dark,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Navbar(),
    );
  }
}
