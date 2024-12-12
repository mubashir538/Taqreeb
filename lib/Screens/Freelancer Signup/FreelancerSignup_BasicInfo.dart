import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/images.dart';

class FreelancerSignup_BasicInfo extends StatelessWidget {
  const FreelancerSignup_BasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController fullnamecontroller = TextEditingController();
    TextEditingController usernamecontroller = TextEditingController();
    TextEditingController portfoliocontroller = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: "Create A Freelancer Account",
              para:
                  "Earn a Soothing Income by Editing Videos or Pictures of Events",
              image: MyImages.FreelancerSignup,
            ),
            SizedBox(
              height: MaximumThing * 0.05,
            ),
            MyTextBox(hint: "Enter Full Business Name",valueController: fullnamecontroller,),
            MyTextBox(hint: "Enter Username",valueController: usernamecontroller,),
            MyTextBox(hint: "Enter Portfolio Link",valueController: portfoliocontroller,),
            SizedBox(
              height: screenHeight * 0.05,
              child: MyDivider(),
            ),
            ColoredButton(
              text: "Continue",
              onPressed: () {
                Navigator.pushNamed(context, '/FreelancerSignup_Description');
              },
            )
          ],
        ),
      ),
    );
  }
}
