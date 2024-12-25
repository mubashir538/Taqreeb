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

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    SizedBox(height: (screenHeight * 0.01) + _headerHeight),
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
                        if (gender.isEmpty || city.isEmpty) {
                          warningDialog(
                                  title: 'Details Missing',
                                  message: 'Please fill all the fields')
                              .showDialogBox(context);
                        } else {
                          MyStorage.saveToken(city, 'scity');
                          MyStorage.saveToken(gender, 'sgender');
                          Navigator.pushNamed(context, '/ProfilePictureUpload',
                              arguments: {'type': 'user'});
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
          Positioned(
            child: Header(
              key: _headerKey,
              heading: 'OTP Verification',
              para: 'Unlock exclusive events - sign up now!',
              image: MyImages.Signup1,
            ),
          ),
        ],
      ),
    );
  }
}
