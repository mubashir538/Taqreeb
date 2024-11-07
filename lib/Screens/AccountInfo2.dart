import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/navbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AccountInfo2 extends StatelessWidget {
  const AccountInfo2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Header(
              heading: "Edit Your Personal Info",
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
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
                    "Change Profile Picture",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                        color: MyColors.Yellow),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ]),
            SizedBox(
              height: 20,
            ),

            //TextBoxes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Full Name",
                    //textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white)),
                MyTextBox(hint: ''),
                SizedBox(
                  height: 30,
                ),
                Text("Username",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white)),
                MyTextBox(hint: ''),
                SizedBox(
                  height: 30,
                ),
                Text("Location",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MyColors.white)),
                MyTextBox(hint: ''),
                SizedBox(
                  height: 30,
                ),
              ],
            ),

            //Divider
            MyDivider(width: screenWidth * 0.6),
            const SizedBox(height: 10),

            //Colored Button
            ColoredButton(text: 'Save'),
            SizedBox(
              height: 30,
            ),

            //Navbar
            Navbar(),
            // FloatingActionButton(
            //   onPressed: () {},
            //   backgroundColor: MyColors.Yellow,
            //   child: Icon(Icons.add, color: MyColors.red),
            // ),
          ]),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: Navbar(),
    );
  }
}
