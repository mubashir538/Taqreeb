import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class ForgotPassword_VerifyCode extends StatefulWidget {
  const ForgotPassword_VerifyCode({super.key});

  @override
  State<ForgotPassword_VerifyCode> createState() =>
      _ForgotPassword_VerifyCodeState();
}

class _ForgotPassword_VerifyCodeState extends State<ForgotPassword_VerifyCode> {
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: _headerHeight),
                Container(
                    margin: EdgeInsets.only(
                        top: MaximumThing * 0.07, bottom: MaximumThing * 0.02),
                    child: OTPBoxes(
                      onChanged: (value) {},
                    )),
                Text(
                  'Send Code Again 00:59',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: MaximumThing * 0.015,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Verification',
                  onPressed: () {
                    Navigator.pushNamed(context, '/ForgotPassword_NewPassword');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Verify Code',
              para: 'We have send the code to abc@gmail.com',
            ),
          ),
        ],
      ),
    );
  }
}
