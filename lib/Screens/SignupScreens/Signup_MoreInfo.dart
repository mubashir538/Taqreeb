import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class Signup_MoreInfo extends StatefulWidget {

  
  Signup_MoreInfo({super.key});

  @override
  State<Signup_MoreInfo> createState() => _Signup_MoreInfoState();
}

class _Signup_MoreInfoState extends State<Signup_MoreInfo> {
  String city = "";
  String gender = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Header(
                  heading: 'OTP Verification',
                  para: 'Unlock exclusive events - sign up now!',
                  image: MyImages.Signup1,
                ),
                SizedBox(height: screenHeight * 0.01),
                ResponsiveDropdown(
                    items: ["Karachi", "Lahore", "Islamabad", "Peshawar"],
                    labelText: "City",
                    onChanged: (value) {
                      setState(() {
                        city = value.toString();
                      });
                    }),
                ResponsiveDropdown(
                    items: ["Male", "Female"],
                    labelText: "Gender",
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    }),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Continue',
                  onPressed: () {
                    if (gender.isEmpty ||
                        city.isEmpty) {
                      warningDialog(
                              title: 'Details Missing',
                              message: 'Please fill all the fields')
                          .showDialogBox(context);
                    } else {
                      MyStorage.saveToken(city, 'scity');
                      MyStorage.saveToken(
                          gender, 'sgender');
                      Navigator.pushNamed(context, '/ProfilePictureUpload');
                    }
                  },
                ),
              ]),
              ProgressBar(
                Progress: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
