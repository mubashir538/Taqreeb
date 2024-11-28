import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/OTP%20Boxes.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class ForgotPassword_VerifyCode extends StatelessWidget {
  const ForgotPassword_VerifyCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 244,
            width: 431,
            decoration: BoxDecoration(
              color: MyColors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(MyIcons.arrowLeft),
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      "Taqreeb",
                      style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: MyColors.white),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Upload your ID Card for Verification",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: MyColors.Yellow,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "We have sent the code to abc@gmail.com",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),

          // Wrapping OTPBoxes in Center
          Center(
            child: OTPBoxes(),
          ),
        ],
      ),
    );
  }
}

