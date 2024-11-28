import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';

class ForgotPassword_NewPassword extends StatelessWidget {
  const ForgotPassword_NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: "Create New Password",
              para:
                  "This password should br different  from the previous password",
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Row(children: [
                  SizedBox(
                    width: 50,
                  ),
                  Icon(Icons.check, size: 20, color: MyColors.white),
                  SizedBox(
                    width: 20,
                  ),
                  Text("At least 8 characters"),
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  SizedBox(
                    width: 50,
                  ),
                  Icon(Icons.check, size: 20, color: MyColors.white),
                  SizedBox(
                    width: 20,
                  ),
                  Text("At least 1 number"),
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  SizedBox(
                    width: 50,
                  ),
                  Icon(Icons.check, size: 20, color: MyColors.white),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Both upper and lower case letters"),
                ]),
              ],
            ),
            SizedBox(height: 50),
            Container(
              width: 370,
              child: Divider(
                color: MyColors.DarkLighter,
                thickness: 1.5,
              ),
            ),
            SizedBox(height: 30),
            ColoredButton(text: "Reset Password")
          ],
        ),
      ),
    );
  }
}
