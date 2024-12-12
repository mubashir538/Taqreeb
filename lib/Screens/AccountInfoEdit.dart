import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class AccountInfoEdit extends StatelessWidget {
  const AccountInfoEdit({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;


    TextEditingController fnamecontroller = TextEditingController();
    TextEditingController usernamecontroller = TextEditingController();
    TextEditingController locationcontroller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Header(
              heading: "Edit Your Personal Info",
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MaximumThing * 0.04,
                  horizontal: MaximumThing * 0.02),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2016/12/09/09/52/girl-1894125_640.jpg"),
                ),
                Container(
                  margin: EdgeInsets.only(left: MaximumThing * 0.02),
                  child: Text(
                    "Change Profile Picture",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        decoration: TextDecoration.underline,
                        fontSize: MaximumThing * 0.015,
                        fontWeight: FontWeight.w400,
                        color: MyColors.Yellow),
                  ),
                ),
              ]),
            ),

            Column(
              children: [
                MyTextBox(hint: 'Full Name',valueController: fnamecontroller),
                MyTextBox(hint: 'Username',valueController: usernamecontroller),
                MyTextBox(hint: 'Location',valueController: locationcontroller),
              ],
            ),

            //Divider
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            //Colored Button
            ColoredButton(
              text: 'Save',
              onPressed: () {
                Navigator.pushNamed(context, '/AccountInfo');
              },
            ),
            SizedBox(
              height: 30,
            ),
          ]),
        ),
      ),
    );
  }
}
