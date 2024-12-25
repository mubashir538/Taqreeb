import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class ForgotPassword_EmailorPhoneInput extends StatefulWidget {
  const ForgotPassword_EmailorPhoneInput({super.key});

  @override
  State<ForgotPassword_EmailorPhoneInput> createState() =>
      _ForgotPassword_EmailorPhoneInputState();
}

class _ForgotPassword_EmailorPhoneInputState
    extends State<ForgotPassword_EmailorPhoneInput> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
  }

  TextEditingController contactController = TextEditingController();
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
            child: Column(
              children: [
                SizedBox(height: _headerHeight),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                  child: MyTextBox(
                    hint: "Enter Email/Phone Number",
                    valueController: contactController,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: "Send Code",
                  onPressed: () {
                    Navigator.pushNamed(context, '/ForgotPassword_VerifyCode');
                  },
                )
              ],
            ),
          ),
          Positioned(
            child: Header(
              key: _headerKey,
              heading: 'Forgot Password',
              para:
                  'Enter the email address with your account  and we’ll send an email with confirmation to restetyour password',
              image: MyImages.ForgotPassword,
            ),
          ),
        ],
      ),
    );
  }
}
