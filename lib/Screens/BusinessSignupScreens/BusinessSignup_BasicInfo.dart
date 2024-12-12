import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class BusinessSignup_BasicInfo extends StatelessWidget {
  const BusinessSignup_BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController cnicController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            MyTextBox(hint: 'CNIC',valueController: cnicController,),
            MyTextBox(hint: 'City',valueController: cityController,),
            MyTextBox(hint: 'Category',valueController: categoryController,),
            MyTextBox(hint: 'Username',valueController: usernameController,),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: MyDivider()),
            ),
            ColoredButton(
              onPressed: () {
                Navigator.pushNamed(context, '/BusinessSignup_CNICUpload');
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
