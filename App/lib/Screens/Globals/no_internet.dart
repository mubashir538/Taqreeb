import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/images.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Header(),
          SizedBox(height: Screen.max(context) * 0.03),
          Center(
            child: SizedBox(
              height: Screen.height(context) * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: Screen.width(context) * 0.8,
                    height: Screen.height(context) * 0.4,
                    child: Image.asset(MyImages.noInternet, fit: BoxFit.contain),
                  ),
                  SizedBox(height: Screen.max(context) * 0.02),
                  Text(
                    'No Internet Connection',
                    style: GoogleFonts.roboto(
                        color: MyColors.red,
                        fontSize: Screen.max(context) * 0.025,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: Screen.max(context) * 0.02),
                  Text(
                    'Oops! Looks like you are not connected to the internet. Please check your internet connection and try again.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: MyColors.white,
                        fontSize: Screen.max(context) * 0.015,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: Screen.max(context) * 0.03),
                  BorderButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    text: 'Retry',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
