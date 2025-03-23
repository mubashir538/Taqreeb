import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class Signup_MoreInfo extends StatefulWidget {
  Signup_MoreInfo({super.key});

  @override
  State<Signup_MoreInfo> createState() => _Signup_MoreInfoState();
}

class _Signup_MoreInfoState extends State<Signup_MoreInfo> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
                            cityController.text = value.toString();
                          });
                        }),
                    ResponsiveDropdown(
                        items: ["Male", "Female"],
                        labelText: "Gender",
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value.toString();
                          });
                        }),
                    MyTextBox(
                        hint: 'Enter Your Age',
                        valueController: ageController,
                        isNum: true),
                    SizedBox(
                      height: screenHeight * 0.1,
                      child: Center(child: MyDivider()),
                    ),
                    ColoredButton(
                      text: 'Continue',
                      onPressed: () {
                        if (genderController.text.isEmpty ||
                            cityController.text.isEmpty ||
                            ageController.text.isEmpty) {
                          warningDialog(
                                  title: 'Details Missing',
                                  message: 'Please fill all the fields')
                              .showDialogBox(context);
                        } else if (int.parse(ageController.text) < 18) {
                          warningDialog(
                                  title: 'Invalid Age',
                                  message:
                                      'User should be atleast 18 years old')
                              .showDialogBox(context);
                        } else {
                          MyStorage.saveToken(cityController.text, 'scity');
                          MyStorage.saveToken(genderController.text, 'sgender');
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
            top: 0,
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
