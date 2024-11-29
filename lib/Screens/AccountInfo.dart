import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    double size = MaximumThing * 0.03;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          Header(
            heading: "My Profile",
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MaximumThing * 0.02, vertical: MaximumThing * 0.03),
            child: Text(
                "Here is the account information for your profile,please review and ensure all details are accurate for a seamless experience.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //Circle Avatar
            SizedBox(
              width: screenWidth * 0.9,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/12/09/09/52/girl-1894125_640.jpg"),
                ),
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Column(
                    children: [
                      Text(
                        "Wishma Khan",
                        style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w600,
                            color: MyColors.white),
                      ),

                      // //+Add Status
                      // Text(
                      //   '+ Add Status',
                      //   style: GoogleFonts.montserrat(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w700,
                      //     color: MyColors.Yellow,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ]),
            ),

            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider()),
            ),

            //Username
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: Text(
                'Username',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.02,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow,
                ),
              ),
            ),

            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      MyIcons.profile,
                      width: size,
                      height: size,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MaximumThing * 0.02),
                      child: Text(
                        'Wishmak12',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w200,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ]),
            ),

            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider(width: screenWidth * 0.7)),
            ),

            //Phone
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: Text(
                'Phone',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.02,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow,
                ),
              ),
            ),

            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone,
                      color: MyColors.white,
                      size: size,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MaximumThing * 0.02),
                      child: Text(
                        '03225354325',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w200,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ]),
            ),

            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider(width: screenWidth * 0.7)),
            ),

            //Email
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: Text(
                'Email',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.02,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow,
                ),
              ),
            ),

            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      MyIcons.email,
                      width: size,
                      height: size,
                      color: MyColors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MaximumThing * 0.02),
                      child: Text(
                        'Wishmak@gmail.com',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w200,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ]),
            ),

            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider(width: screenWidth * 0.7)),
            ),

            //Location
            Padding(
              padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child: Text(
                'Location',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: MaximumThing * 0.02,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow,
                ),
              ),
            ),

            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: MyColors.white,
                      size: size,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: MaximumThing * 0.02),
                      child: Text(
                        'Karachi',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: MaximumThing * 0.015,
                          fontWeight: FontWeight.w200,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ]),
            ),

            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: MyDivider(width: screenWidth * 0.7)),
            ),
          ])
        ]),
      )),
    );
  }
}
