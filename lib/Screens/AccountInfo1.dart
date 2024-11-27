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

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      child: Column(children: [
        Header(
          heading: "My Profile",
        ),
        SizedBox(
          height: 10,
        ),

        //Text
        Text(
            "Here is the account information for your profile;\n"
            "please review and ensure all details are accurate for\n"
            "a seamless experience.",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: MyColors.white)),
        SizedBox(
          height: 20,
        ),

        //Circle Avatar
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 30,
            height: 40,
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2016/12/09/09/52/girl-1894125_640.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text(
                "wishma khan",
                style: GoogleFonts.montserrat(
                    fontSize: 23,
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
        ]),

        //divider
        MyDivider(width: screenWidth * 0.6),
        const SizedBox(height: 10),

        //Username
        Text(
          'Username',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.Yellow,
          ),
        ),

        Column(children: [
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                SvgPicture.asset(MyIcons.profile),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Wishmak12',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ]),
          MyDivider(width: screenWidth * 0.6),
          const SizedBox(height: 10),
        ]),

        //Phone
        Text(
          'Phone',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.Yellow,
          ),
        ),

        Column(children: [
          SizedBox(
            width: 30,
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.phone),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '03352798062',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ]),
          MyDivider(width: screenWidth * 0.6),
          const SizedBox(height: 10),
        ]),

        //Email
        Text(
          'Email',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.Yellow,
          ),
        ),

        Column(children: [
          SizedBox(
            width: 30,
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.email),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Wishmak78@gmail.com',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ]),
          MyDivider(width: screenWidth * 0.6),
          const SizedBox(height: 10),
        ]),

        //Location
        Text(
          'Location',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: MyColors.Yellow,
          ),
        ),

        Column(children: [
          SizedBox(
            width: 30,
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.location_city),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Karachi',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ]),
          MyDivider(width: screenWidth * 0.6),
          const SizedBox(height: 30),
        ]),

        //Navbar
        Navbar(),
      ]),
    )));
  }
}
